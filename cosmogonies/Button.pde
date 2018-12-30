/*This class provides buttons to select different modes for drawing.
The Modes are divided in two categories: CREATOR (to create Sun, Wave and Bubble objects),
and EDITOR (to scale, move, delete objects)*/

enum ButtonType {CREATOR, EDITOR, NONE}

class Button{
  
  Mode mode;
  ButtonType type;
  float radius;
  float x;
  float y;
  
  Button(float x, float y, float radius, Mode mode, ButtonType type){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.mode = mode;
    this.type = type;
  }
  
  void display(){
    if (type == ButtonType.CREATOR){
      ellipse(x, y, radius, radius);
    }
    else {
      rect(x-radius/2, y-radius/2, radius, radius);
    }
    
    float innerRad = radius/3;
    float margin = radius/2 - radius/3;
    switch(mode){
      case WAVE: //draw a wave
      Wave wave = new Wave(3, radius/50, radius/1500, x-radius/2, y, radius-margin, radius/150);
      stroke(0);
      strokeWeight(1);
      wave.display();
      break;
      case BUBBLE: //draw a bubble
      drawBubble(x, y, innerRad, 0.4, NoiseMode.GAUSSIAN);
      break;
      case SUN: //drawSun(x, y, innerRad, 60, color(255));
      stroke(200, 150, 0);
      drawStar(x,y, innerRad, innerRad /200);
      break;
      case MOON: drawMoon(x, y, innerRad, 50, color(255));
      break;
      case ERASER: //draw an x-shaped cross
      stroke(255,0,0);
      line(x - margin, y - margin, x + margin, y + margin);
      line(x + margin, y - margin, x - margin, y + margin);
      break;
      case ANCHOR: //draw an anchor
      strokeWeight(1);
      stroke(255,0,0);
      line(x, y - radius/2 + margin , x, y + radius/2 - margin);
      line(x - radius/2 + margin, y, x + radius/2 - margin, y);
      PVector point1 = new PVector(x - margin, y + 2 * margin);
      PVector point2 = new PVector(x, y + radius/2);
      PVector point3 = new PVector(x + margin, y+2*margin);
      fill(255,0,0);
      triangle(point1.x, point1.y,point2.x, point2.y, point3.x, point3.y);
      noFill();
      ellipse(x, y-radius/2 + margin, margin, margin);
      arc(x, y + radius/2 -2*margin, radius/2, radius/2, 0, PI, OPEN);
      break;
      case SCALE: //draw a square and an upwards diagonal arrow
      stroke(255,0,0);
      rect(x-radius/2, y, radius/2, radius/2);
      line( x - radius/2, y + radius/2, x + margin, y - margin);
      line(x, y - margin, x + margin, y - margin);
      line(x + margin, y , x + margin, y - margin);
      break;
      case NONE:;
      break;
      default:;
    }
  }
  
  boolean mouseOnButton(){
    if(mouseX >= x - radius && mouseX <= x + radius
       && mouseY >= y-radius && mouseY <= y +radius){
      return true;
    }
    return false;
  }
  
  Mode mode(){
    return mode;
  }
  
  ButtonType type(){
    return type;
  }
}
