/*******************************************************
 
 BASE CLASS: "Defense Mania"
 
 Bachelorarbeit von Kris Siepert - Sommersemester 2012
 Studiengang Medienproduktion & Medientechnik an der Hochschule für angewandte Wissenschaften Amberg-Weiden
 
 Kommentare des Programm-Codes sind auf Englisch verfasst.
 
 *******************************************************/

import java.io.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.JOptionPane;

/*******************************************************
 
 Global variables
 
 *******************************************************/

float menuScale = 1;
float hudScale = 1;
int globalPlatform = 0; /* 0 = PC, 1 = Android, 2 = Browser */
String[] updateRequest;
boolean updateMe = false;
String[] versionStrings;
String globalVersionName;
int globalVersion;

/*******************************************************
 
 Set the whole thing up
 
 *******************************************************/

void setup() {

  /*Set size, orientation & framerate*/
  size(960, 600);
  frameRate(60);

  /*Set version*/
  globalVersionName = "0.9b2";
  globalVersion = 92;

  /*Load fonts & set title*/
  fpsFont = createFont("Arial", 48);    
  frame.setTitle("Defense Mania " + globalVersionName);

  /*Initialise main game objects*/
  theAnimations = new ANIMATIONS();
  theMenu = new MENU(0, false);

  /*Add a mousewheel listener for PC*/
  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
    }
  }
  );  
  
  updateRequest = loadStrings("http://update.defensemania.de/?v="+globalVersion);
  if(updateRequest != null && Integer.parseInt(updateRequest[0]) == 1) {
     println("update available");
     updateMe = true;
  } 
  
}

/*******************************************************
 
 It's time to draw some fancy stuff
 
 *******************************************************/

void draw() {  
  if( updateMe == true ) {
    int updateDialog = javax.swing.JOptionPane.showConfirmDialog(null, "A new version of Defense Mania is available. Would you like to update now?", "Update available", JOptionPane.YES_NO_OPTION, JOptionPane.INFORMATION_MESSAGE);
    if( updateDialog == 0 ) {
      
      String osName = System.getProperty("os.name");
      if( osName.startsWith("Mac") ) {
        open("http://files.defensemania.de/dist/mac/latest.zip");
      } else if( osName.startsWith("Win") ) {
        open("http://files.defensemania.de/dist/win/latest.zip");
      } else {
        open("http://files.defensemania.de/dist/linux/latest.zip");
      }
      exit();
      
    }
    updateMe = false;
  }
  mouseXp = (int) (mouseX/scaleFactor);
  mouseYp = (int) (mouseY/scaleFactor);
  globalDisplay();
}

/*******************************************************
 
 Input
 
 *******************************************************/

/*
 MouseReleased only for Menu-Buttons
 */
void mouseReleased() { 
  if (theMenu != null) {
    theMenu.mouseClicked();
  }
}

/*
 MouseClicked
 */
void mouseClicked() {
  if (inputHandler != null) {
    inputHandler.mouseClick();
  }
}

/*
 MouseDragged
 */
void mouseDragged() {
  if (inputHandler != null) {
    if (mouseButton == RIGHT) {
      inputHandler.scroll((mouseX-pmouseX)*0.7, (mouseY-pmouseY)*0.7);
    }
  }
}

/*
 MouseWheel
 */
void mouseWheel(int delta) {
  if (inputHandler != null) { 
    inputHandler.zoom(delta*-0.06);
  }
  if (theMenu != null) {
    theMenu.scroll(delta*-2);
  }
}
