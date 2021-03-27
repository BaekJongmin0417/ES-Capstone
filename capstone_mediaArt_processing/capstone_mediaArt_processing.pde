

/* 2020-2 ES-엔터테인먼트SW미디어프로젝트캡스톤디자인
<미디어아트> 이금형, 백종민, 윤강민
프로젝트 '플랑팡 블루' 
프로세싱 코드 

2020-2 ES-Entertainment SW Media Project Capstone Design
<Media Art> Lee Geum Hyeoung, Baek Jong Min, Yoon Gang Min
Project 'Plangpang Blue' 
Processing Code */

import KinectPV2.KJoint;
import KinectPV2.*;

// Kinect
KinectPV2 kinect;
boolean human = false;

PGraphics pg1;
PGraphics pg2;

// Background
ArrayList<Brush> brushes; 

// Stars
int numStars = 300;
stars[] nightSky = new stars [numStars];

// Plankton & Firework
int numParts = 100;
int iter = 0;
ArrayList<Particle> parts = new ArrayList<Particle>();
ArrayList<Firework> fires = new ArrayList();

// color range to randomize
int rv = 1, gv = 193, bv = 245; // bright
int rv1 = 68, gv1 =108, bv1 = 179; // dark 

void setup() {
  fullScreen();

  /* Kinect Setting */
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();

  pg1 = createGraphics(width, height);
  pg2 = createGraphics(width, height);

  // Background Setting
  pg1.beginDraw();
  brushes = new ArrayList<Brush>();
  for (int i = 0; i < 100; i++) {
    brushes.add(new Brush());
  }
  pg1.endDraw();

  // Plankton & Stars Setting 
  pg2.beginDraw();
  createStars();
  pg2.endDraw();
}

void createStars() {
  for (int i = 0; i < numStars; i++) 
    nightSky[i] = new stars();
}

void createParts() {
  parts.add(new Particle(random(20, width-20), random(20, height-20), iter++));
}

void draw() {
  // Draw Background on pg1 
  pg1.beginDraw();
  for (Brush brush : brushes) {
    brush.paint();
  }
  pg1.endDraw();

  // Draw Parts on pg2
  pg2.clear();
  pg2.beginDraw();

  // stars code
  for (int i = 0; i<numStars; i++) 
    nightSky[i].display();

  // plankton code 
  if (!human && iter < numParts)
    createParts();

  // kinect code
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  if (skeletonArray.size() != 0) {
    //println(human);
    human = true;
  } else {
    //println(human);
    human = false;
  }
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);

    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      drawHand(joints[KinectPV2.JointType_HandRight]);
      drawHand(joints[KinectPV2.JointType_HandLeft]);

      // catch plankton
      catchPlankton(joints[KinectPV2.JointType_HandRight]);
      catchPlankton(joints[KinectPV2.JointType_HandLeft]);
    }
  }

  drawPlankton();
  pg2.endDraw();

  // Draw pg1 & pg2
  clear();
  background(64, 90, 185);
  image(pg1, 0, 0);
  image(pg2, 0, 0);

  /* Print FrameRate */
  fill(255, 0, 0);
  //text(frameRate, 50, 50);
}

void catchPlankton(KJoint joint) {
  // plankton code 
  for (int i =0; i < parts.size(); i++) {
    Particle temp = parts.get(i);
    float xx = joint.getX()-temp.x;
    float yy = joint.getY()-temp.y;
    float distance = sqrt(xx*xx +yy*yy);
    float minDist = temp.w>temp.h?temp.w:temp.h;

    // catch a particle, then it explodes and disappears
    if (distance<minDist) {
      boom(temp.x, temp.y, parts.get(i).c);
      parts.remove(i);
    }
  }

  // firework code 
  for (Firework thisFirework : fires) 
    thisFirework.spark();
}

void drawPlankton() {
  for (int i =0; i < parts.size(); i++) {
    parts.get(i).update();
    parts.get(i).display();
  }

  // add parts when there is no human
  if (!human && parts.size() < numParts) {
    iter = parts.size();
  }
}

void boom(float x, float y, color c) {
  fires.add(new Firework(x, y, c));
}

void drawHand(KJoint joint) {
  pg2.noFill();
  pg2.strokeWeight(3);
  pg2.stroke(255);
  pg2.ellipse(joint.getX(), joint.getY(), 50, 50); 
  pg2.arc(joint.getX()+10, joint.getY(), 50, 50, PI, PI+QUARTER_PI);
  pg2.arc(joint.getX()-5, joint.getY()-5, 50, 50, 0, HALF_PI);
}
