
class stars {
  float starsXPosition;
  float starsYPosition;
  float starsWidth;
  float offset;

  stars() {
    starsXPosition = random(width);
    starsYPosition = random(height);
    starsWidth = random(.2, 3);
    offset = .02;
  }

  void display () {
    pg2.fill(random(255));
    pg2.noStroke();

    pg2.ellipse (starsXPosition, starsYPosition, starsWidth, starsWidth);
    if (starsXPosition > width) {
      starsXPosition =0;
    }
    starsXPosition += offset;
  }
}
