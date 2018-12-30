/*
Cosmogonies 
project by Noemie Pierre-Jean - 2018
Realised as part of a Computational Media course, National Cheng Kung University.

This program is constructed as a minimal and playful drawing application, which allows the user to create organic looking shapes, reminiscent of a universe in formation.
Users can invent their own universe using waves, bubbles, moon and suns animated shapes.
Clickable buttons activate the different drawing and editing modes. Use the mouse (by clicking and dragging) to create, rescale, move and delete shapes.
**/

/*SAVING LOCATION FOR IMAGES */
String images_location = "images/";
/** INITIALIZE ANIMATION VARIABLES **/
float time = 0;
float scaleFactor = 0;

/** INITIALIZE INTERFACE **/
//ToolBar
PVector toolBarDim;

//Buttons
Button bubbleButton = new Button(50, 50, 60, Mode.BUBBLE, ButtonType.CREATOR);
Button sunButton = new Button(50, 125, 60, Mode.SUN,  ButtonType.CREATOR);
Button moonButton = new Button(50, 200, 60, Mode.MOON,  ButtonType.CREATOR);
Button waveButton = new Button(50, 275, 60, Mode.WAVE,  ButtonType.CREATOR);
Button anchorButton = new Button(50, 350, 50, Mode.ANCHOR,  ButtonType.EDITOR);
Button scaleButton = new Button(50, 425, 50, Mode.SCALE,  ButtonType.EDITOR);
Button eraserButton = new Button(50, 500, 50, Mode.ERASER,  ButtonType.EDITOR);
Button[] buttons = {bubbleButton, sunButton, moonButton, waveButton, anchorButton, scaleButton, eraserButton};

//Modes
Mode mode = Mode.NONE;
ButtonType modeType = ButtonType.NONE;
boolean dragAndDrawMode = false;

/** INITIALIZE DRAWABLE OBJECTS **/
Wave wave1 = new Wave(3, 10, 0.2, 200, 200, 500, 5);//new Wave(3, 20, 0.5);
ArrayList<Drawable> drawnObjects = new ArrayList<Drawable>();

void setup(){
  frameRate(5);
  size(800,600);
  //noStroke();
  fill(color(75,75,200));
  strokeWeight(1);
  toolBarDim = new PVector(100, height);
}

void draw(){
 // background(color(20,20,90));
 // background(color(60,246,246));
 background(0);
 time += 0.02;
 
  //render all objects in list
  for(Drawable drawn : drawnObjects){
    drawn.display();
  }
  
  //DRAW TOOLBAR
 fill(200);
 rect(0,0, toolBarDim.x, toolBarDim.y);
 noFill();
  for(Button button : buttons){
    button.display();
  }
}


/*KEYBOARD EVENTS*/

void keyPressed(){
  if(key == 's'){
    save(images_location + "screenshot.png");
  }
}
/*MOUSE EVENTS*/
/*Each mouse event activates a mode, or creates or edits an object, depending on the mode selected by the user.*/

/*click to create or delete objects*/
void mouseClicked(){
  boolean onToolBar = false;
  //index of selected object. It is equal to -1 if no object is selected.
  int selectedObject = mouseSelect(drawnObjects);
  if(mouseX < 120){
    onToolBar = true;
  }
  
  //If a button is clicked, activate the corresponding mode.
  for(int i = 0; i < buttons.length; i++){
    if (buttons[i].mouseOnButton()){
      mode = buttons[i].mode();
      modeType = buttons[i].type();
      break;
    }
  }
  
  //If the canvas (but not the toolbar) is clicked, create or edit objects according to the selected mode and object.
  if(!onToolBar){
    switch(mode){
      case WAVE:
      //Add a wave to the list of objects to render
      drawnObjects.add(new Wave(3, 10, 0.2, mouseX, mouseY, 100, 5));
      break;
        
      case BUBBLE:
      //Add a bubble to the list of objects to render
      NoiseMode noiseMode;
      FillMode fillMode = FillMode.randomMode();
      if (fillMode == FillMode.FILL || fillMode == FillMode.GRADIENT){
        noiseMode = NoiseMode.SINE;
      }
      else noiseMode = NoiseMode.randomMode();
      drawnObjects.add(new Bubble(float(mouseX), float(mouseY), 50, 0.2, noiseMode, fillMode));
      break;
        
      case SUN:
      //Add a sun to the list of objects to render.
      drawnObjects.add(new Sun(mouseX, mouseY, 50, 60, color(255)));
      break;
      
      case MOON:
      //Add a sun to the list of objects to render.
      drawnObjects.add(new Moon(mouseX, mouseY, 50, 50, color(255)));
      break;
   
      case ERASER:
      //If an object is selected, delete clicked object from the list of objects to render.
      if(selectedObject != -1){
        drawnObjects.remove(selectedObject);
        break;
      }
        
      case ANCHOR:
      break;
        
      case NONE:
      break;
      default:;
    }
  }
}

/*Drag the mouse to create, scale or move objects*/
void mouseDragged(){
  boolean onToolBar = false;
  int selectedObject = -1;
  selectedObject = mouseSelect(drawnObjects);
  
  if(mouseX < 120){
    onToolBar = true;
  }
  //TODO: refactorize this part
  if(!onToolBar){
    switch(mode){
      //When in WAVE, SUN or BUBBLE mode,
      //Create an object and increment its size as it follows the mouse.
      case WAVE:
      if(dragAndDrawMode) drawnObjects.remove(drawnObjects.size()-1);
      scaleFactor += 0.8;
      Wave wave = new Wave(3, scaleFactor/12, 0.2, mouseX, mouseY, scaleFactor, 5); 
      drawnObjects.add(wave);
      dragAndDrawMode = true;
      break;
        
      case BUBBLE:
      if(dragAndDrawMode) drawnObjects.remove(drawnObjects.size()-1);
      scaleFactor += 0.8;
      NoiseMode noiseMode = NoiseMode.randomMode();
      FillMode fillMode = FillMode.randomMode();
      if (fillMode == FillMode.FILL || fillMode == FillMode.GRADIENT){
        noiseMode = NoiseMode.SINE;
      }
      Bubble bubble = new Bubble(mouseX, mouseY, 0+scaleFactor, 0.2, noiseMode , fillMode); 
      drawnObjects.add(bubble);
      dragAndDrawMode = true;
      break;
        
      case SUN:
      //If in drag-and-draw mode, remove the last added object, and replace it by a new object at the updated position.
      if(dragAndDrawMode) drawnObjects.remove(drawnObjects.size()-1);
      scaleFactor += 0.8;
      Sun sun = new Sun(mouseX, mouseY, 0 + scaleFactor, 0 + scaleFactor, color(255));
      drawnObjects.add(sun);
      dragAndDrawMode = true;
      break;
      
      case MOON:
      //If in drag-and-draw mode, remove the last added object, and replace it by a new object at the updated position.
      if(dragAndDrawMode) drawnObjects.remove(drawnObjects.size()-1);
      scaleFactor += 0.8;
      Moon moon = new Moon(mouseX, mouseY, 0 + scaleFactor, 0 + scaleFactor, color(255));
      drawnObjects.add(moon);
      dragAndDrawMode = true;
      break;
      
      case ERASER:;
      break;
      
      case SCALE:
      //If an object is selected, move it along with the mouse.
      if(selectedObject != -1){
        float sign = 1;
        if(mouseX < pmouseX) sign = -1;
        scaleFactor += 0.1 * sign;
        Drawable object = drawnObjects.get(selectedObject);
        drawnObjects.set(selectedObject, object.getScaled(scaleFactor));
      }
      break;
        
      case ANCHOR:
      //If an object is selected, move the object to the current mouse position.
      if(selectedObject != -1){
          Drawable object = drawnObjects.get(selectedObject);
          drawnObjects.set(selectedObject, object.getMoved(mouseX, mouseY));
        }
      break;
        
      case NONE:;
      break;
      default:;
    }
  }
}

//Reinitialize the variables that were changed when dragging the mouse.
void mouseReleased(){
  dragAndDrawMode = false;
  scaleFactor = 0;
}

/*SELECTION*/
/*Return the index of the current object selected by the mouse in the drawnObjects list.
If no object is selected, return -1.
*/
int mouseSelect(ArrayList<Drawable> drawnObjects){
  int selected = -1; //equal to -1 if no object is selected
  int i = 0;
  for(Drawable drawn : drawnObjects){
    if(drawn.isOnObject(mouseX, mouseY)){
      selected = i;
      break;
    }
    i++;
  }
  return selected;
}
