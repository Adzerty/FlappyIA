int generation = 0;
int POP_SIZE = 100;

Flappy[] flappies;

int PIPE_WIDTH = 75;
int PIPE_SPEED = 8;
int PIPE_SPACE = 250;

ArrayList<Pipe> pipes = new ArrayList<>();
ArrayList<Pipe> pipesToRemove = new ArrayList<>();


PrintWriter output;

void setup() {
  size(800, 600);



  flappies = new Flappy[POP_SIZE];

  for (int i = 0; i<POP_SIZE; i++) {
    flappies[i] = new Flappy(new PVector(100, 300));
    flappies[i].addNeuron(new Neuron((int)random(-100, 100), (int)random(-100, 100), 30, flappies[i]));
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
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, TAB);
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      int w = int(pieces[2]);
      int h = int(pieces[3]);

      generateNewPipe(x, y, w, h);
    }
    reader.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void generateNewPipe(int x, int y, int w, int h) {
  pipes.add(new Pipe(new PVector(x, y), w, h));
}


void generateNewPipes(int x) {

  int pipeHeight1 = (int)random(50, 350);
  int pipeHeight2 = height - PIPE_SPACE - pipeHeight1;

  pipes.add(new Pipe(new PVector(x, 0), PIPE_WIDTH, pipeHeight1));
  pipes.add(new Pipe(new PVector(x, height - pipeHeight2), PIPE_WIDTH, pipeHeight2));
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
    //generateNewPipes(width);
  }

  fill(0, 200, 200);
}




void end() {
  Flappy bestFlap = null;
  for (Flappy f : flappies) {
    if (bestFlap == null || bestFlap.score < f.score) {
      bestFlap = f;
    }
  }
  println("GENERATION "+generation +" ETEINTE !");
  println("SCORE MAX " + bestFlap.score);
  
  exit();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      //flap.jump();
    }
  }
}
