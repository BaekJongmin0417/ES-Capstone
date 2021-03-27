
class Firework {
  float x, y; 
  color c;
  ArrayList<Particle> sparks = new ArrayList();

  Firework(float xx, float yy, color cc) {
    x = xx;
    y = yy;
    c = cc;
    for (int iter=0; iter<100; iter++) 
      sparks.add(new Particle(x, y, iter));
  }

  // firework
  void spark() { 
    pg2.fill(c);
    for (Particle thisParticle : sparks)
      thisParticle.spark();
  }
}
