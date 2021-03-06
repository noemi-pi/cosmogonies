/*The Bubble class provides methods to create and modify an animated bubble pattern.
It is implemented as a sum of a circle or a disc and noise generated by different functions*/

import java.util.Collections;
import java.util.Arrays;
import java.util.Random;
import java.util.List;

class Bubble implements Drawable{
  float x;
  float y;
  float radius;
  float step;
  NoiseMode noiseMode;
  FillMode fillMode;
  
  Bubble(float x, float y, float radius, float step, NoiseMode noiseMode, FillMode fillMode){
  this.x =x;
  this.y = y;
  this.radius = radius;
  this.step = step;
  this.fillMode = fillMode;
  this.noiseMode = noiseMode;
  }
  
  void display(){
    if(radius <= 0) radius = 1;
    switch(fillMode){
      case FILL:
      drawFilledBubble(x, y, radius, step, noiseMode);
      break;
      case NOFILL:
      drawBubble(x, y, radius, step, noiseMode);
      break;
      case GRADIENT:
      drawGradientBubble(x, y, radius, step, noiseMode);
      break;
      default: 
      drawBubble(x, y, radius, step, noiseMode);
    }
  }
  
  Bubble getScaled(float scaleFactor){
    return new Bubble(this.x, this.y, this.radius + scaleFactor, this.step, this.noiseMode, this.fillMode);
  }
  
  Bubble getMoved(float xmove, float ymove){
     return new Bubble(xmove, ymove, this.radius, this.step, this.noiseMode, this.fillMode);
  }
  
  boolean isOnObject(float xtest, float ytest){
    if(xtest >= x - radius && xtest <= x + radius
       && ytest >= y-radius && ytest <= y +radius){
      return true;
    }
    return false;
  }  
}

//allow to randomly choose a type of noise
enum NoiseMode{
  GAUSSIAN, PERLIN, SINE;
  private static final List<NoiseMode> VALUES =
    Collections.unmodifiableList(Arrays.asList(values()));
  private static final int SIZE = VALUES.size();
  private static final Random RANDOM = new Random();

  public static NoiseMode randomMode()  {
    return VALUES.get(RANDOM.nextInt(SIZE));
  }
}

//allow to randomly choose a fill mode, i.e. whether the bubble is filled with a single color, filled with a gradient of colors, or not filled at all.
enum FillMode{
  FILL, NOFILL, GRADIENT;

  private static final List<FillMode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));
  private static final int SIZE = VALUES.size();
  private static final Random RANDOM = new Random();

  public static FillMode randomMode()  {
    return VALUES.get(RANDOM.nextInt(SIZE));
  }
}

//Drawing functions used for rendering Bubble shapes
void drawBubble(float x, float y, float radius, float step, NoiseMode noiseMode){
  noiseDetail(10, 0.65);
  float pInit = sin(random(0, TWO_PI));
  pInit = sin(time);
  float p = pInit;
  float mult = 1;
  float startX = 0;
  float startY = 0;
  float pointX = 0;
  float pointY = 0;
  startX = x + radius * cos(p) + noiseSin(p, mult, noiseMode);
  startY = y + radius * sin(p) +  noiseCos(p, mult, noiseMode);
  float prevX = startX;
  float prevY = startY;
  while (p < pInit + TWO_PI - step){
    p = p + step;
    pointX = x + radius * cos(p) + noiseSin(p, mult, noiseMode);
    pointY = y + radius * sin(p) + noiseCos(p, mult, noiseMode);
    strokeWeight(1);
    stroke(45,45/(p+0.5), 255/(p+0.5));
    line(prevX, prevY, pointX,pointY);
    prevX = pointX;
    prevY = pointY;
  }
  pointX = startX;
  pointY = startY;
  line(prevX, prevY, pointX, pointY);
}

float noiseSin(float p, float mult, NoiseMode mode){
  switch(mode){
    case GAUSSIAN:
    return mult * sin(randomGaussian());

    case PERLIN:
    mult*= 20;
    return mult * noise(sin(p * time));
    
    case SINE:
    mult*= 5;
    return sin(mult * (p + time));
    
    default:
    return mult * noise(sin(p * time));
  }  
}

float noiseCos(float p, float mult, NoiseMode mode){
  switch(mode){
    case GAUSSIAN:
    return mult * cos(randomGaussian());

    case PERLIN:
    mult*= 20;
    return mult * noise(cos(p * time));
    
    case SINE:
    mult*= 5;
    return sin(mult * (p + time));
    
    default:
    return mult * noise(cos(p * time));
  } 
}

void drawFilledBubble(float x, float y, float radius, float step, NoiseMode noiseMode){
  noiseDetail(10, 0.65);
  float pInit = sin(random(0, TWO_PI));
  pInit = sin(time);
  float p = pInit;
  float mult = 10;
  float pointX = 0;
  float pointY = 0;
  float r, g, b;
  r = 0;
  g = 0;
  b = 200;
  color c = color(r, g, b);
  fill(100,0,255);
  beginShape();
  while (p <= pInit + TWO_PI){
    pointX = x + radius * cos(p) + noiseSin(p, mult, noiseMode);
    pointY = y + radius * sin(p) + noiseCos(p, mult, noiseMode);
    fill(100,0,255);
    r+=1;
    b+=1;
    g+=1;
    c = color(r, g, b);
    strokeWeight(1);
    stroke(c);
    //noStroke();
    vertex(pointX, pointY);
    p = p + step;
  }
  endShape();
}

void drawGradientBubble(float x, float y, float radius, float step, NoiseMode noiseMode){
  noiseDetail(10, 0.65);
  //step = 0.05;
  step = 5 /radius;
  float pInit = sin(time);
  pInit = 0;
  float p = pInit;
  float mult = 0.5;
  float startX = 0;
  float startY = 0;
  float pointX = 0;
  float pointY = 0;
  if(noiseMode == NoiseMode.SINE){
    mult = 2;
  }
  color c = color(45,45/(p+0.5), 255/(p+0.5));
  startX = x + radius * cos(p) + noiseSin(p, mult, noiseMode);
  startY = y + radius * sin(p) + noiseCos(p, mult, noiseMode);
  float prevX = startX;
  float prevY = startY;
  float pc = pInit + TWO_PI - step;
  while (p < pInit + TWO_PI){
    p = p + step;
    pointX = x + radius * cos(p) + noiseSin(p, mult, noiseMode);
    pointY = y + radius * sin(p) + noiseCos(p, mult, noiseMode);
    strokeWeight(1);
    if (p < PI) c = color(45,145/(pc-(p+step)), 255/(pc-(p+step))+mult*sin(time));
    else c = color(45,145/(p-step), 255/(p-step)+mult*cos(time));
    stroke(c);
    //noStroke();
    fill(c);
    triangle(prevX, prevY, pointX,pointY,x,y);
    prevX = pointX;
    prevY = pointY;
  }
}
