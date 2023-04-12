class NeuronsGroup extends Sensor {

  ArrayList<Sensor> sensors = new ArrayList<>();
  boolean active = false;

  public NeuronsGroup(ArrayList<Sensor> s) {
    sensors = s;
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
}
