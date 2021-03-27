
class Particle {
  float x, y; 
  float w, h, r;
  color c;
  int idx;

  // moving
  float nx = 1;
  float ny = 1;

  // firework
  float direct; // direction 
  float speed;

  Particle(float xx, float yy, int id) {
    x = xx;
    y = yy;
    w = random(10, 20); 
    h = random(10, 20);
    c = color(random(rv1, rv), random(gv1, gv), random(bv1, bv));
    r = random(90);
    idx = id;

    if (int(w)%2!=0)
      nx*=-1;
    if (int(h)%2!=0)
      ny*=-1;

    // firework
    direct = random(TWO_PI);
    speed = random(2, 5);
  }

  void display() {
    pg2.noStroke();

    switch(idx%3) {
    case 0: // one circle 
      /*pg2.fill(c, 30);
       for (float i=6; i>0; i-=1) {
       pg2.ellipse(x, y, w/5*i, h/4*i);
       }*/
      pg2.fill(c, 180);
      pg2.ellipse(x, y, w, h);
      break;

    case 1: // cell(flower)
      pg2.push();
      pg2.translate(x, y);
      pg2.rotate(radians(r));
      
      pg2.fill(c, 180);
      pg2.ellipse(-5, -5, 20, 20);
      pg2.ellipse(+5, -5, 20, 20);
      pg2.ellipse(-5, +5, 20, 20);
      pg2.ellipse(+5, +5, 20, 20);
      pg2.pop();
      break;

    case 2: // circles 
      //fill(c, 80);
      pg2.push();
      pg2.translate(x, y);
      if (nx > 0 && ny > 0)
        pg2.rotate(radians(135));
      else if (nx < 0 && ny > 0)
        pg2.rotate(radians(225));
      else if (nx > 0 && ny < 0)
        pg2.rotate(radians(45));
      else
        pg2.rotate(radians(-45));
        
      pg2.fill(37, 116, 169, 170);//jelly bean color
      for (int i=0; i<3; i++) {
        pg2.ellipse(0, 8*i, 8+4*i, 8+4*i);
      }
      pg2.fill(58, 83, 155, 140);//chambray color
      for (int i=3; i<6; i++) {
        pg2.ellipse(0, 8*i, 8+4*i, 8+4*i);
      }
      pg2.pop();
      break;
    }
  }

  //moving
  void update() {
    x += nx;
    y += ny;

    if (x <= 0 + w/2 || width - w/2 <= x) {
      nx *= -1;
    }
    if (y <= 0 + h/2 || height - h/2 <= y) {
      ny *= -1;
    }
  }

  // firework
  void spark() {
    w -= 0.5;
    h -= 0.5;
    if (w < 0 || h < 0)
      return;

    x += sin(direct) * speed;
    y += cos(direct) * speed;

    pg2.noStroke();
    pg2.ellipse(x, y, w, h);
  }
}
