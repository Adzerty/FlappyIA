import java.util.Arrays;

int generation = 0;
int lastScoreMax = 0;
int POP_SIZE = 300;

Flappy[] flappies;

int PIPE_WIDTH = 75;
int PIPE_SPEED = 4;
int PIPE_SPACE = 250;

ArrayList<Pipe> pipes = new ArrayList<>();
ArrayList<Pipe> pipesToRemove = new ArrayList<>();
ArrayList<JSONObject> densityArray = new ArrayList<>();

PrintWriter output;



void setup() {
  size(800, 600);

  flappies = new Flappy[POP_SIZE];

  for (int i = 0; i<POP_SIZE; i++) {
    flappies[i] = new Flappy(new PVector(100, 300));

    float r = random(0, 1);
    if (r < -0.33) {
      flappies[i].addSensor(new Neuron((int)random(-100, 250), (int)random(-250, 250), 30, flappies[i], false));
    } else {
      if (r < -0.66) {
        flappies[i].addSensor(new AirNeuron((int)random(-100, 250), (int)random(-250, 250), 30, flappies[i], false));
      } else {
        ArrayList<Sensor> s = new ArrayList<>();

        for (int j = 0; j< random(5); j++) {
          float r2 = random(0, 1);
          if (r2 < 0.5) {
            s.add(new Neuron((int)random(-100, 250), (int)random(-250, 250), 30, flappies[i], true));
          } else {
            s.add(new AirNeuron((int)random(-100, 250), (int)random(-250, 250), 30, flappies[i], true));
          }

          NeuronsGroup g = new NeuronsGroup(s, flappies[i]);
          flappies[i].addSensor(g);
        }
      }

      //flappies[i] = new Flappy(new PVector(100, 300), json);
    }
  }

  /*
  generateNewPipes(300);
   generateNewPipes(600);
   for (int i = 0; i<150; i++) {
   generateNewPipes(width + (i* 300));
   }
   */

  parseFile();
}

void parseFile() {
  // Open the file from the createWriter() example
  BufferedReader reader = createReader("pipetrainingset.dat");
  String line = null;
  int i = 1;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, TAB);
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      int w = int(pieces[2]);
      int h = int(pieces[3]);

      generateNewPipe(x, y, w, h, i++);
    }
    reader.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void generateNewPipe(int x, int y, int w, int h, int n) {
  pipes.add(new Pipe(new PVector(x, y), w, h, n));
}



void draw() {
  background(120);



  int deathCount = 0;
  for (Flappy flap : flappies) {
    flap.applyGravity();
    flap.move();
    flap.show();
    flap.check(pipes);

    if (flap.dead) deathCount ++;
  }

  if (deathCount == POP_SIZE) {
    end();
  }

  boolean removed = false;
  for (Pipe p : pipes) {
    p.move();
    p.show();

    if (p.tL.x + PIPE_WIDTH <= 0) {
      pipesToRemove.add(p);
      removed = true;
    }
  }


  if (removed) {
    pipes.removeAll(pipesToRemove);
    pipesToRemove.clear();
  }

  fill(0, 200, 200);

  fill(255,100,250);
  textSize(20);
  text("Génération : " + generation, 0, 20);
  text("Dernier score max : " + lastScoreMax, 0, 40);
}




void end() {
  Arrays.sort(flappies);

  println("GENERATION "+generation +" ETEINTE !");
  println("SCORE MAX " + flappies[0].score);
  lastScoreMax = flappies[0].score;

  for (int i = 0; i < POP_SIZE / 2; i++) {
    saveJSONObject(flappies[i].toJson(), "data/"+generation+"/best"+i+".json");
  }

  evolve();


  pipesToRemove.clear();
  pipes.clear();
  parseFile();
}


void evolve() {
  JSONObject flap, flap1, flap2;
  flappies = new Flappy[POP_SIZE];
  
  densityArray.clear();
  
  for(int i = 0; i<POP_SIZE /2; i++){
    flap = loadJSONObject("data/"+generation+"/best"+i+".json");
    int flapScore = flap.getInt("score");
    for(int j = 0; j<flapScore;j++){
      densityArray.add(flap);
    }
  }

  for (int i = 0; i < POP_SIZE / 2; i++) {
    int r = i;
    do {
      r = (int)random(0, densityArray.size());
    } while (r == i);

    flap1 = loadJSONObject("data/"+generation+"/best"+i+".json");
    flap2 = densityArray.get(r);

    flappies[i] = new Flappy(new PVector(100, 300), flap1, flap2);
    flappies[POP_SIZE / 2 + i] = new Flappy(new PVector(100, 300), flap1);
  }


  for (Flappy f : flappies) {
    float r = random(0, 1);
    if (r < 0.3) {
      f.mutate();
    }
  }



  generation++;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      //flap.jump();
    }
  }
}
