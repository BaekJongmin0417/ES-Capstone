

// Stars
int numStars = 300;
stars[] nightSky = new stars [numStars];

// Plankton & Firework
int numParts = 100;
ArrayList<Particle> parts = new ArrayList<Particle>();
ArrayList<Firework> fires = new ArrayList();

// 랜덤 추출할 색 범위
//int colour = #01C1F5; // 밝은 색 hex 
int rv = 1, gv = 193, bv = 245; // 밝은 색
int rv1 = 68, gv1 =108, bv1 = 179; // 어두운 색(San Marino)
int av = 80; // alpha value

// Background
ArrayList<Brush> brushes; 

PGraphics pg1;
PGraphics pg2;

void setup() {
  //size(800, 450); //16:9
  size(1920, 1080);
  //background();

  pg1 = createGraphics(width, height);
  pg2 = createGraphics(width, height);

  pg1.beginDraw();
  brushes = new ArrayList<Brush>();
  for (int i = 0; i < 100; i++) {
    brushes.add(new Brush());
  }
  pg1.endDraw();

  pg2.beginDraw();
  /* Plankton & Stars Setting */
  createParts();
  createStars();
  pg2.endDraw();
}

void createStars() {
  for (int i = 0; i < numStars; i++) 
    nightSky[i] = new stars();
}

void createParts() {
  for (int i=0; i<numParts; i++) {
    parts.add(new Particle(random(20, width-20), random(20, height-20), i));
  }
}

void draw() {
  pg1.beginDraw();
  for (Brush brush : brushes) {
    brush.paint();
  }
  pg1.endDraw();

  /* Background Setting */
  //fill(#041D39, 80);   //fill(4,29,57,80);
  //fill(0, 0, 0, 10);
  //rect(0, 0, width, height);

  pg2.clear();
  pg2.beginDraw();
  /* Stars Code */
  //clear();
  for (int i = 0; i<numStars; i++) 
    nightSky[i].display();

  /*fill(221, 50, 18, 20);
   noStroke();*/

  /* Plankton Code */
  drawPlankton();
  pg2.endDraw();

  // drawing
  clear();
  background(64, 90, 185);//background(#6599D6);
  image(pg1, 0, 0);
  image(pg2, 0, 0);
}

void drawPlankton() {
  /* Particle Code */
  for (int i =0; i < parts.size(); i++) {
    Particle temp = parts.get(i);
    float xx = mouseX-temp.x;
    float yy = mouseY-temp.y;
    float distance = sqrt(xx*xx +yy*yy);
    float minDist = temp.w>temp.h?temp.w:temp.h;

    // 파티클 클릭 시 터지면서 사라짐
    if (mousePressed && distance<minDist) {
      boom(parts.get(i).c);
      parts.remove(i);
    } else {
      parts.get(i).update();
      parts.get(i).display();
    }
  }
  // add parts when parts are less than total/10
  if (parts.size() < numParts/10)
   createParts();

  /* Firework Code */
  for (Firework thisFirework : fires) 
    thisFirework.spark();
}

void boom(color c) {
  fires.add(new Firework(mouseX, mouseY, c));
}
