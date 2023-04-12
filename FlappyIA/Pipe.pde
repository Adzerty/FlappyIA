class Pipe{

  PVector tL;
  int w;
  int h;
  
  public Pipe(PVector tL, int w, int h){
    this.tL = tL;
    this.w = w;
    this.h = h;
  }
  
  public void move(){
     this.tL.x -= PIPE_SPEED;
  }
  
  public void show(){
    fill(0,200,0);
    rect(tL.x, tL.y, w, h);
  }
}
