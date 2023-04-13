class NeuronsGroup extends Sensor {

  float ADD_FACT = 0.1;
  float REM_FACT =  0.15;

  ArrayList<Sensor> sensors = new ArrayList<>();
  boolean active = false;

  color c = color(random(255), random(255), random(255));

  public NeuronsGroup(ArrayList<Sensor> s, Flappy flap) {
    sensors = s;
    this.flap = flap;
  }

  void isActive() {


    for (Sensor s : sensors) {
      if (s.active == false) {
        active = false;
        return;
      }
    }
    active = true;
    flap.jump();
  }

  @Override
    public void check(ArrayList<Pipe> pipes) {
    active = false;
    for (Sensor s : sensors) {
      s.check(pipes);
    }
    isActive();
  }

  public void mutate() {
    for (Sensor s : sensors) {
      s.mutate();
    }

    float r = random(0, 1);

    Sensor toRemove = null;

    if (r < ADD_FACT) {
      float r2 = random(0, 1);
      if (r2 < 0.5) {
        sensors.add(new Neuron((int)random(-100, 250), (int)random(-250, 250), 30, flap, true));
      } else {
        sensors.add(new AirNeuron((int)random(-100, 250), (int)random(-250, 250), 30, flap, true));
      }
    } else {
      if (sensors.size() > 1 && r < ADD_FACT + REM_FACT) {
        toRemove = sensors.get((int) random(0, sensors.size()));
      }
    }
    if (toRemove != null) {
      sensors.remove(toRemove);
    }
  }


  @Override
    public void show() {
    stroke(c);
    for (Sensor s : sensors) {
      s.show();
    }
    stroke(0);
  }
}
