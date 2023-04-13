class Pipe {

  PVector tL;
  int w;
  int h;

  int n;

  public Pipe(PVector tL, int w, int h, int n) {
    this.tL = tL;
    this.w = w;
    this.h = h;
    this.n = n;
  }

  public void move() {
    this.tL.x -= PIPE_SPEED;
  }

  public void show() {
    fill(0, 200, 0);
    rect(tL.x, tL.y, w, h);
    if (n%2 == 0) {
      fill(0, 250, 120);
      textSize(42);
      text(""+(n/2), tL.x, tL.y);
    }
  }
}
