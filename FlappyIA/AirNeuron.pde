class AirNeuron extends Neuron {

  //positons offset based on flappy pos
  int xOffset;
  int yOffset;

  int size;

  public AirNeuron(int x, int y, int s) {
    super(x, y, s);
  }

  @Override
    public void check(ArrayList<Pipe> pipes) {
    active = false;
    //Check world constrains
    if (! (flap.pos.y + yOffset > height - size || flap.pos.y + yOffset <= 0) ) {
      activate();
    }

    //Check nearest pipes constrains
    for (Pipe p : pipes) {
      check(p);
    }
  }

  private void check(Pipe p) {
    if (! (flap.pos.x + xOffset + size >= p.tL.x &&    // r1 right edge past r2 left
      flap.pos.x + xOffset <= p.tL.x + p.w &&    // r1 left edge past r2 right
      flap.pos.y + yOffset + size >= p.tL.y &&    // r1 top edge past r2 bottom
      flap.pos.y + yOffset <= p.tL.y + p.h)) {    // r1 bottom edge past r2 top
      activate();
    }
  }

  public void activate() {
    this.active = true;
    flap.jump();
  }
}