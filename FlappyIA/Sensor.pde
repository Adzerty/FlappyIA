abstract class Sensor {
  Flappy flap;

  boolean active;
  abstract void check(ArrayList<Pipe> al);
}
