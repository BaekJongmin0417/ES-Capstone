

/* 2020-2 ES-엔터테인먼트SW미디어프로젝트캡스톤디자인
 *  <미디어아트> 이금형, 백종민, 윤강민
 *  프로젝트 '플랑팡 블루' 
 *  아두이노 코드 
 *  
 *  2020-2 ES-Entertainment SW Media Project Capstone Design
 *  <Media Art> Lee Geum Hyeoung, Baek Jong Min, Yoon Gang Min
 *  Project 'Plangpang Blue' 
 *  Arduino Code */

#include <Adafruit_NeoPixel.h>

#define NUM_PIXELS 300
#define PIN_NEO1 6
#define PIN_NEO2 10

#define ON HIGH // 1: led 켜지는 중
#define OFF LOW // 0: led 꺼지는 중
#define WAIT 2 // ledMode 준비 중

Adafruit_NeoPixel pixels1 = Adafruit_NeoPixel(NUM_PIXELS, PIN_NEO1, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel pixels2 = Adafruit_NeoPixel(NUM_PIXELS, PIN_NEO2, NEO_GRB + NEO_KHZ800);

int RADER = 13; // rader sensor
int raderState = LOW; // rader status control
int ledMode = WAIT; // led(neopixel) control

int line = 54; // number of pixels in a row of leds
int c[3][3] = {{31, 58, 147}, {34, 167, 240}, {25, 181, 254}}; // color values

void pixelSetting() {
  pixels1.begin();
  pixels2.begin();
  pixels1.setBrightness(50);
  pixels2.setBrightness(50);
  pixelClear();
}

void setup() {
  pinMode(RADER, INPUT);
  Serial.begin(9600);

  pixelSetting();
}

void loop() {
  raderState = digitalRead(RADER);

  // rader 인식 여부 판단
  if (raderState == HIGH) {
    if (ledMode == WAIT) {
      Serial.println("Motion Detected");
      ledMode = ON;
    }
  }

  // led 모드 제어
  if (ledMode == ON) {
    pixelOn(0);
    delay(400);
  }
  else if (ledMode == OFF) {
    pixelOff(0);
    delay(400);
  }
}

int colorSet(int idx) {
  if (0 <= idx && idx < line * 2)
    return 0;
  else if (line * 2 <= idx && idx < line * 4)
    return 1;
  else
    return 2;
}

void pixelOn(int idx) {
  if (idx >= NUM_PIXELS) {
    ledMode = OFF;
    return;
  }
  if (idx == 0) {
    Serial.println("LED ON");
  }

  int ci = colorSet(idx);
  for (int i = idx; i < idx + line; i++) {
    pixels1.setPixelColor(i, c[ci][0], c[ci][1], c[ci][2]);
    pixels2.setPixelColor(i, c[ci][0], c[ci][1], c[ci][2]);
  }
  pixels1.show();
  pixels2.show();
  delay(300);

  pixelOn(idx + line);
}

void pixelOff(int idx) {
  if (idx >= NUM_PIXELS) {
    ledMode = WAIT;
    Serial.println("LED WAITING");
    return;
  }
  if (idx == 0) {
    Serial.println("LED OFF");
  }

  for (int i = idx; i < idx + line; i++) {
    pixels1.setPixelColor(i, 0, 0, 0);
    pixels2.setPixelColor(i, 0, 0, 0);
  }
  pixels1.show();
  pixels2.show();
  delay(300);

  pixelOff(idx + line);
}

void pixelClear() {
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels1.setPixelColor(i, 0, 0, 0);
    pixels2.setPixelColor(i, 0, 0, 0);
  }
  pixels1.show();
  pixels2.show();
}
