/*The Moon class provides methods to create and modify an animated Moon pattern, with an animation of the Moon's phases (waxing and waning) 
*/

enum MoonPhase{
  Gibbous, Crescent
}

enum MoonState{
 Waxing, Waning
}

class Moon implements Drawable{
  float x;
  float y;
  float radius;
  float density;
  color baseColor;
  boolean isCrescent;
  float shadowRadius;
  float sign;
  MoonState moonState;
  
  Moon(float x, float y, float radius, float density, color baseColor){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.density = density;
    this.baseColor = baseColor;
    this.shadowRadius = radius;
    this.isCrescent = true;
    this.sign = 1;
    this.moonState = MoonState.Waning;
  }
  
  void display(){
    //drawMoon(x, y, radius, density, baseColor);
    updateState();
    drawMoonPhases(x, y, radius, shadowRadius,  moonState, isCrescent);
  }
  
  void updateState(){
    
    if((int)shadowRadius >= radius) {
      sign = -1;
      switch(moonState){
        case Waning: 
        moonState = MoonState.Waxing;
        break;
        case Waxing:
        moonState = MoonState.Waning;
        break;
        default:;
      }
    }
    if((int)shadowRadius <= 0) {
      sign = 1;
      isCrescent = !isCrescent;
    }

    shadowRadius += 1 * sign;

  }
  void moveTo(float xmove, float ymove){
    this.x = xmove;
    this.y = ymove;
  }
  
  Moon getMoved(float xmove, float ymove){
    return new Moon(xmove, ymove, this.radius, this.density, this.baseColor);
  }
  
  Moon getScaled(float scaleFactor){
    return new Moon(this.x, this.y, radius + scaleFactor, this.density, this.baseColor);
  }
  
  boolean isOnObject(float xtest, float ytest){
    if(xtest >= x - radius && xtest <= x + radius
       && ytest >= y-radius && ytest <= y +radius){
      return true;
    }
    return false;
  }
}

void drawMoonPhases(float x, float y, float radius, float shadowRadius, MoonState moonState, boolean isCrescent){
  noFill();
  stroke(255);
  pushMatrix();
  translate(x,y);
  rotate(radians(90));
  translate(-x, -y);
  for(int i = (int)(x - radius); i < x + radius; i++){
    for(int j = (int)(y - radius); j < y + radius; j++){
      if(  isInCircle(i, j, radius, x, y)
      && !isInMoonShadow(i, j, radius, shadowRadius, x, y, isCrescent, moonState)){
        if((int)random(4) == 1) line(i, j, i+1, j+1);
      }
    }
  }
  popMatrix();
}

void drawMoon(float x, float y, float radius, float density, color baseColor){
  noFill();
  stroke(baseColor);
  for(int i = (int)(x - radius); i < x + radius; i++){
    for(int j = (int)(y - radius); j < y + radius; j++){
      if(sq(i -x) + sq(j-y) < sq(radius)){
        if((int)random(4) == 1) line(i, j, i+1, j+1);
      }
    }
  }
}

boolean isInCircle(float x, float y, float radius, float centerX, float centerY){
  return (sq(x -centerX) + sq(y-centerY) < sq(radius));
}

boolean isInEllipse(float x, float y, float radius1, float radius2, float centerx, float centery){
  //compute ellipse cartesian equation
  x -= centerx;
  y -= centery;
  float c = radius1;
  float a = sqrt(sq(radius2) + sq(c));
  float ellipseFormula = sqrt(sq(x-c) + sq(y)) + sqrt(sq(x+c) + sq(y));
  if( ellipseFormula < 2*a){
    return true;
  }
  return false;
}

boolean isInMoonShadow(float x, float y, float radius1, float radius2, float centerx, float centery, boolean isCrescent, MoonState moonState){
  
  switch(moonState){
    case Waning:
    if(isCrescent){
      if(isInEllipse(x, y, radius1, radius2, centerx, centery) ||
      (y > centery && y < centery + radius1)){
        return true;
      }  
    } 
    else {
      if(!isInEllipse(x, y, radius1, radius2, centerx, centery) &&
      (y > centery && y < centery + radius1)){
        return true;
      }
    }
    break;
    case Waxing:
    if(isCrescent){
      if(isInEllipse(x, y, radius1, radius2, centerx, centery) ||
      (y < centery && y > centery - radius1)){
        return true;
      }  
    } 
    else {
      if(!isInEllipse(x, y, radius1, radius2, centerx, centery) &&
      (y < centery && y > centery - radius1)){
        return true;
      }
    }
    break;
    default:;
  }
  return false;
}
