Flappy flap;

int PIPE_WIDTH = 75;
int PIPE_SPEED = 15;
int PIPE_SPACE = 250;

ArrayList<Pipe> pipes = new ArrayList<>();
ArrayList<Pipe> pipesToRemove = new ArrayList<>();

int score = 0;

PrintWriter output;

void setup() {
  size(800, 600);
  flap = new Flappy(new PVector(100, 300));

  //flap.addNeuron(new Neuron((int)random(-100,100), (int)random(-100,100), 30));

  /*
  generateNewPipes(300);
  generateNewPipes(600);
  for (int i = 0; i<150; i++) {
    generateNewPipes(width + (i* 300));
  }
  */

}

void generateNewPipes(int x) {

  int pipeHeight1 = (int)random(50, 350);
  int pipeHeight2 = height - PIPE_SPACE - pipeHeight1;

  pipes.add(new Pipe(new PVector(x, 0), PIPE_WIDTH, pipeHeight1));
  pipes.add(new Pipe(new PVector(x, height - pipeHeight2), PIPE_WIDTH, pipeHeight2));
  
  addScore();
}

void draw() {
  background(120);

  flap.applyGravity();
  flap.move();
  flap.show();
  flap.check(pipes);

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
  textSize(20);
  text("Score : " + score, 0, 20);
}


public void addScore() {
  score ++;
  if (score % 25 == 0 && PIPE_SPACE > 100) {
    PIPE_SPACE -= 30;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      flap.jump();
    }
  }
}
