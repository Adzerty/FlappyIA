class Flappy implements Comparable {

  int score = 0;

  PVector acc;
  PVector vel;
  PVector pos;

  int MAX_SPEED = 8;

  int jumping = 0;

  PVector GRAVITY = new PVector(0, 1);
  PVector WIND = new PVector(1, 0);

  int size = 40;

  boolean dead = false;

  float MUTATE_FACTOR = 0.3;
  float EVOLVE_FACTOR = 0.5;

  ArrayList<Sensor> neuralNetwork =  new ArrayList<>();
  ArrayList<Sensor> neuronsToRemove = new ArrayList<>();
  boolean removed;


  public Flappy(PVector p, JSONObject f1, JSONObject f2) {
    this.pos = p;
    this.vel = new PVector();
    this.acc = new PVector();

    //Creation des neurones
    JSONArray sensors = f1.getJSONArray("sensors");
    addFromJSONArray(sensors);

    sensors = f2.getJSONArray("sensors");
    addFromJSONArray(sensors);
    
    removed = false; 
    for(Sensor n : neuralNetwork){
      float r = random(0,1);
      if(neuralNetwork.size() > 1 && r < EVOLVE_FACTOR){
        neuronsToRemove.add(n);
        removed = true;
      }
    }
    
    if(removed){
      neuralNetwork.removeAll(neuronsToRemove);
    }
  }





  public Flappy(PVector p, JSONObject j) {
    this.pos = p;
    this.vel = new PVector();
    this.acc = new PVector();

    //Creation des neurones
    JSONArray sensors = j.getJSONArray("sensors");
    for (int i = 0; i<sensors.size(); i++) {
      String type = sensors.getJSONObject(i).getString("type");

      if (type.equals("N")) {
        addNeuronFromJson(sensors.getJSONObject(i));
      } else {
        if (type.equals("A")) {
          addAirNeuronFromJson(sensors.getJSONObject(i));
        } else {
          addNeuronsGroupFromJson(sensors.getJSONObject(i));
        }
      }
    }
  }


  public Flappy(PVector p) {
    this.pos = p;
    this.vel = new PVector();
    this.acc = new PVector();
  }

  public void jump() {

    jumping = 10;
  }

  public void applyGravity() {
    this.acc.add(GRAVITY);

    if (jumping > 0) {
      this.acc.y *= -10;
    }
  }

  public void move() {
    if (!dead) {
      this.vel.add(acc);
      this.vel.limit(MAX_SPEED);
      this.pos.add(vel);

      this.acc.mult(0);
      this.jumping--;
    }
  }

  public void show() {
    if (dead) {
      fill(200, 0, 0, 10);
    } else {
      fill(255, 255, 0);
    }

    rect(pos.x, pos.y, size, size);


    if (! dead) {
      for (Sensor n : neuralNetwork) {
        n.show();
      }
    }
  }

  public void check(ArrayList<Pipe> pipes) {
    if (!dead) {
      //Check world constrains
      if (pos.y > height - size || pos.y <= 0) {
        dead = true;
      }

      if (pipes.size() > 2) {
        //Check nearest pipes constrains
        Pipe p1 = pipes.get(0);
        Pipe p2 = pipes.get(1);

        if (p1 != null) check(p1);
        if (p2 != null) {
          check(p2);
          checkScore(p2);
        }
      }

      for (Sensor n : neuralNetwork) {
        n.check(pipes);
      }
    }
  }

  private void check(Pipe p) {
    if (pos.x + size >= p.tL.x &&    // r1 right edge past r2 left
      pos.x <= p.tL.x + p.w &&    // r1 left edge past r2 right
      pos.y + size >= p.tL.y &&    // r1 top edge past r2 bottom
      pos.y <= p.tL.y + p.h) {    // r1 bottom edge past r2 top
      dead= true;
    }
  }

  private void checkScore(Pipe p) {
    if (pos.x >= p.tL.x + p.w - 2 && pos.x <= p.tL.x + p.w + 2) {
      addScore();
    }
  }

  public void addSensor(Sensor s) {
    this.neuralNetwork.add(s);
  }

  public void addScore() {
    score ++;
  }

  int compareTo(Object o) {
    Flappy f = (Flappy)o;
    return f.score - score;
  }

  void mutate() {
    for (Sensor s : neuralNetwork) {
      float r = random(0, 1);
      if (r < MUTATE_FACTOR) {
        s.mutate();
      }
    }
  }


  //SERIALIZATION
  JSONObject toJson() {
    JSONObject json = new JSONObject();
    JSONArray sensors = new JSONArray();

    int i = 0;
    for (Sensor s : neuralNetwork) {
      JSONObject sensor = new JSONObject();
      if (s instanceof Neuron) {
        addNeuronToJson(sensor, (Neuron) s);
      } else {
        if (s instanceof AirNeuron) {
          addAirNeuronToJson(sensor, (AirNeuron) s);
        } else {
          addNeuronsGroupToJson(sensor, (NeuronsGroup) s);
        }
      }

      sensors.setJSONObject(i++, sensor);
    }
    json.setJSONArray("sensors", sensors);
    json.setInt("score", score);
    return json;
  }

  private void addNeuronToJson(JSONObject j, Neuron n) {
    j.setString("type", "N");
    j.setInt("x", n.xOffset);
    j.setInt("y", n.yOffset);
    j.setInt("size", n.size);
  }
  private void addAirNeuronToJson(JSONObject j, AirNeuron a) {
    j.setString("type", "A");
    j.setInt("x", a.xOffset);
    j.setInt("y", a.yOffset);
    j.setInt("size", a.size);
  }
  private void addNeuronsGroupToJson(JSONObject j, NeuronsGroup g) {
    j.setString("type", "G");
    JSONArray sensors = new JSONArray();
    int i = 0;
    for (Sensor s : g.sensors) {
      JSONObject sensor = new JSONObject();

      if (s instanceof Neuron) {
        addNeuronToJson(sensor, (Neuron) s);
      } else {
        addAirNeuronToJson(sensor, (AirNeuron) s);
      }

      sensors.setJSONObject(i++, sensor);
    }
    j.setJSONArray("sensors", sensors);
  }

  public void addFromJSONArray(JSONArray sensors) {
    for (int i = 0; i<sensors.size(); i++) {
      String type = sensors.getJSONObject(i).getString("type");

      if (type.equals("N")) {
        addNeuronFromJson(sensors.getJSONObject(i));
      } else {
        if (type.equals("A")) {
          addAirNeuronFromJson(sensors.getJSONObject(i));
        } else {
          addNeuronsGroupFromJson(sensors.getJSONObject(i));
        }
      }
    }
  }


  private void addNeuronFromJson(JSONObject j) {
    Neuron n = new Neuron(j.getInt("x"), j.getInt("y"), j.getInt("size"), this, false);
    this.neuralNetwork.add(n);
  }
  private void addAirNeuronFromJson(JSONObject j) {
    AirNeuron n = new AirNeuron(j.getInt("x"), j.getInt("y"), j.getInt("size"), this, false);
    this.neuralNetwork.add(n);
  }
  private void addNeuronsGroupFromJson(JSONObject j) {
    ArrayList<Sensor> s = new ArrayList<>();

    JSONArray sensors = j.getJSONArray("sensors");
    for (int i = 0; i<sensors.size(); i++) {
      JSONObject obj =  sensors.getJSONObject(i);
      String type = obj.getString("type");

      if (type.equals("N")) {
        s.add(new Neuron(obj.getInt("x"), obj.getInt("y"), obj.getInt("size"), this, false));
      } else {
        s.add(new AirNeuron(obj.getInt("x"), obj.getInt("y"), obj.getInt("size"), this, false));
      }
    }


    NeuronsGroup gn = new NeuronsGroup(s, this);
    this.neuralNetwork.add(gn);
  }
}
