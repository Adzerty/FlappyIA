class NeuronsGroup extends Sensor {

  ArrayList<Neuron> neurons = new ArrayList<>();
  boolean active = false;

  public NeuronsGroup(ArrayList<Neuron> n) {
    neurons = n;
  }

  void isActive() {
    for (Neuron n : neurons) {
      if (n.active == false) {
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
    for (Neuron n : neurons) {
      n.check(pipes);
    }
    isActive();
  }
}
