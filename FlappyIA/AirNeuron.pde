 class AirNeuron extends Sensor {

  //positons offset based on flappy pos
  int xOffset;
  int yOffset;

  int size;

  boolean fromGroup = false;
  
  public AirNeuron(int x, int y, int s, Flappy f, boolean fromGroup) {
    xOffset = x;
    yOffset = y;
    this.size = s;
    active = false;
    flap = f;
    this.fromGroup = fromGroup;
  }

  @Override
    public void show() {
    if (active) {
      fill(255);
    } else {
      noFill();
    }
    ellipse(flap.pos.x + xOffset, flap.pos.y + yOffset, this.size, this.size);
  }

  @Override
    public void check(ArrayList<Pipe> pipes) {
    active = true;
    //Check world constrains
    if (flap.pos.y + yOffset > height - size || flap.pos.y + yOffset <= 0) {
      activate();
    }

    //Check nearest pipes constrains
    for (Pipe p : pipes) {
      check(p);
    }
    if(active && (!fromGroup)){
      flap.jump();
    }
  }

  public void mutate(){
    float offsetX = random(-5,5);
    float offsetY = random(-5,5);
    
    xOffset += offsetX;
    yOffset += offsetY;
  }
  
  private void check(Pipe p) {
    if (flap.pos.x + xOffset + size >= p.tL.x &&    // r1 right edge past r2 left
      flap.pos.x + xOffset <= p.tL.x + p.w &&    // r1 left edge past r2 right
      flap.pos.y + yOffset + size >= p.tL.y &&    // r1 top edge past r2 bottom
      flap.pos.y + yOffset <= p.tL.y + p.h) {    // r1 bottom edge past r2 top
      activate();
    }
  }

  public void activate() {
    this.active = false;
  }
}
