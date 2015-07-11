/*******************************************************
 
 BASE CLASS: "Defense Mania"
 
 *******************************************************/

import java.io.*;
import java.awt.event.*;
import java.util.*;
import android.view.MotionEvent;

/*******************************************************
 
 Global variables
 
 *******************************************************/

TouchProcessor touch;
float menuScale = 1.7;
float hudScale = 1.2;
int globalPlatform = 1;
float originalWidth = 800;

/*******************************************************
 
 Set the whole thing up
 
 *******************************************************/

void setup() {
  
  //Set size, orientation & framerate
  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);
  frameRate(30);
  
  scaleFactor = displayWidth / originalWidth;
  
  width = (int) originalWidth;
  if(scaleFactor > 1d) {
    height = (int) (displayHeight / scaleFactor);
  }

  //Load fonts & set title
  fpsFont = createFont("Arial", 48);    

  //Initialise main game objects
  theAnimations = new ANIMATIONS();
  theMenu = new MENU(0, false);
  touch = new TouchProcessor();

}

/*******************************************************
 
 It's time to draw some fancy stuff
 
 *******************************************************/

void draw() {
  mouseXp = (int) (mouseX/scaleFactor);
  mouseYp = (int) (mouseY/scaleFactor);
  pushMatrix();
  scale((float) scaleFactor);
  touch.analyse();
  touch.sendEvents();    
  globalDisplay();
  popMatrix();
}

/*******************************************************
 
 Android input stuff
 
 *******************************************************/

/*
Single tap/click on the screen
 */
void onTap( TapEvent event ) {
  if ( event.isSingleTap() ) {
    if (inputHandler != null) {     
      inputHandler.mouseClick();
    }
    if (theMenu != null) {
      theMenu.mouseClicked();
    }
  }
}

/*
Dragging around
 */
void onDrag( DragEvent event ) { 
  if (event.numberOfPoints == 1) {
    if (inputHandler != null) {
      inputHandler.scroll(event.dx, event.dy);
    }
    if (theMenu != null) {
      theMenu.scroll(event.dy);
    }
  }
}

/*
Pinching two or more fingers
 */
void onPinch( PinchEvent event ) {
  if (inputHandler != null) {
    inputHandler.zoom(event.amount * 0.003);
  }
}

/*
Setting the back-key to null to prevent quitting the game
 */
void keyPressed() {
  if (key == CODED && keyCode == BACK) {
    keyCode = 0;
  }
}

/*
Override the stock Android touch Event
 */
boolean surfaceTouchEvent(MotionEvent event) {

  // extract the action code & the pointer ID
  int action = event.getAction();
  int code   = action & MotionEvent.ACTION_MASK;
  int index  = action >> MotionEvent.ACTION_POINTER_ID_SHIFT;

  float x = event.getX(index);
  float y = event.getY(index);
  int id  = event.getPointerId(index);

  // pass the events to the TouchProcessor
  if ( code == MotionEvent.ACTION_DOWN || code == MotionEvent.ACTION_POINTER_DOWN) {
    touch.pointDown(x, y, id);
  }
  else if (code == MotionEvent.ACTION_UP || code == MotionEvent.ACTION_POINTER_UP) {
    touch.pointUp(event.getPointerId(index));
  }
  else if ( code == MotionEvent.ACTION_MOVE) {
    int numPointers = event.getPointerCount();
    for (int i=0; i < numPointers; i++) {
      id = event.getPointerId(i);
      x = event.getX(i);
      y = event.getY(i);
      touch.pointMoved(x, y, id);
    }
  }
  return super.surfaceTouchEvent(event);
}

