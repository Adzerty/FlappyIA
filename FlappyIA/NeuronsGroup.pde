class NeuronsGroup extends Sensor {

  ArrayList<Sensor> sensors = new ArrayList<>();
  boolean active = false;
  
  color c = color(random(255),random(255),random(255));

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
  
  @Override
  public void show(){
    stroke(c);
    for(Sensor s : sensors){
      s.show();
    }
    stroke(0);
  }
}
