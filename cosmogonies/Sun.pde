/*The Sun class provides methods to create and modify an animated sun pattern 
*/

class Sun implements Drawable{
  float x;
  float y;
  float radius;
  float density;
  color baseColor;
  
  Sun(float x, float y, float radius, float density, color baseColor){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.density = density;
    this.baseColor = baseColor;
  }
  
  void display(){
    drawSun(x, y, radius, density, baseColor);
  }
  
  void moveTo(float xmove, float ymove){
    this.x = xmove;
    this.y = ymove;
  }
  
  Sun getMoved(float xmove, float ymove){
    return new Sun(xmove, ymove, this.radius, this.density, this.baseColor);
  }
  
  Sun getScaled(float scaleFactor){
    return new Sun(this.x, this.y, radius + scaleFactor, this.density, this.baseColor);
  }
  
  boolean isOnObject(float xtest, float ytest){
    if(xtest >= x - radius && xtest <= x + radius
       && ytest >= y-radius && ytest <= y +radius){
      return true;
    }
    return false;
  }
}

//functions for drawing Sun objects
void drawSun(float x, float y, float radius, float density, color baseColor){
  float green = 50;
  float red = 120;
  if(radius <= 0) radius = 1;
  noFill();
  strokeWeight(radius * 0.001);
  stroke(255,255,0);
  noFill();
  stroke(baseColor);
  for(int i = (int)(x - radius); i < x + radius; i++){
    green++;
    red++;
    stroke(red,green,0);
    for(int j = (int)(y - radius); j < y + radius; j++){
      if(sq(i -x) + sq(j-y) < sq(radius)){
        //if((int)random(4) == 1) line(i, j, i+1, j+1);//simpler version
        if((int)random(density) == 1) drawStar(i,j, radius/10, radius /200);
      }
    }
  }
}

void drawStar(float x, float y, float radius, float step){
  float pInit = sin(random(0, TWO_PI));
  float p = pInit;
  float pointX = 0;
  float pointY = 0;
  while (p < pInit + TWO_PI - step){
    p = p + step;
    float lineScale = random(0,1);
    pointX = x + radius*lineScale * cos(p);
    pointY = y + radius*lineScale * sin(p);
    strokeWeight(radius/1000);
    line(x, y, pointX, pointY);
  }
}
