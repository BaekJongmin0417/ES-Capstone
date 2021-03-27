
class Particle {
  float x, y; 
  float w, h, r;
  color c;
  int id, av;

  // moving
  float nx = 1;
  float ny = 1;

  // firework
  float direct; // direction 
  float speed;

  Particle(float xx, float yy, int iter) {
    x = xx;
    y = yy;
    c = color(random(rv1, rv), random(gv1, gv), random(bv1, bv));
    w = random(10, 20); 
    h = random(10, 20);

    if (iter>0) { // plankton
      if (iter%3 == 0) {
        id = 0;
      } else if (iter%3==1) {
        id = 1;
        w = h = 20;
        r = random(90);
      } else if (iter%3==2) {
        id = 2;
        w = h = 30;
      }
      // moving direction
      if (iter%2 == 0) {
        if (iter%4 == 2)
          nx*=-1;
      } else {
        if (iter%4==3)
          ny*=-1;
      }
    } else { // firework
      direct = random(TWO_PI);
      speed = random(2, 5);
    }
  }

  void display() {
    pg2.noStroke();

    switch(id) {
    case 0: // one circle - width 10~20, height 10~20
      /*pg2.fill(c, 30);
       for (float i=6; i>0; i-=1) {
       pg2.ellipse(x, y, w/5*i, h/4*i);
       }*/
      pg2.fill(c, av);
      pg2.ellipse(x, y, w, h);
      break;

    case 1: // cell(flower) - diagram 20, total 30x30
      pg2.push();
      pg2.translate(x, y);
      pg2.rotate(radians(r++));
      r%=360;

      pg2.fill(c, av);
      pg2.ellipse(-5, -5, w, h);
      pg2.ellipse(+5, -5, w, h);
      pg2.ellipse(-5, +5, w, h);
      pg2.ellipse(+5, +5, w, h);
      pg2.pop();
      break;

    case 2: // circles - diagram 8 12 16 20 24 28, total height 58
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

      pg2.fill(37, 116, 169, av);//jelly bean color
      for (int i=0; i<4; i++) {
        pg2.ellipse(0, 8*i, 8+4*i, 8+4*i);
      }
      //pg2.fill(58, 83, 155, 140);//chambray color
      pg2.fill(58, 83, 185, av); 
      for (int i=4; i<6; i++) {
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
    if (av < 180)
      av+=2;

    if (x <= 0 + w/2 || width - w/2 <= x) 
      nx *= -1;
    if (y <= 0 + h/2 || height - h/2 <= y) 
      ny *= -1;
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
