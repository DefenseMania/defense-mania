/*******************************************************
 
 Class for showing the aftermatch screen
 
 *******************************************************/

class AFTERMATCH {

  /*
  Variables
   */
  BUTTON replayButton;
  BUTTON menuButton;
  BUTTON exitButton;
  float buttonDistance = ((width-(160*3))/4);
  boolean wonTheGame;

  /*
  Constructor
   */
  AFTERMATCH(boolean iwonTheGame) {
    wonTheGame = iwonTheGame;
    replayButton = new BUTTON(0, "PLAY AGAIN", int(buttonDistance), height-65, 160, 26);
    menuButton = new BUTTON(0, "BACK TO MENU", int(buttonDistance*2)+160, height-65, 160, 26);
    exitButton = new BUTTON(0, "EXIT GAME", int(buttonDistance*3)+320, height-65, 160, 26);
  }

  /*
  Display the menu
   */
  void display() {

    pushMatrix();
    translate(0, height*2);
    textFont(fpsFont, 48);
    textAlign(CENTER);

    if (wonTheGame == true) {     
      text("WELL DONE!", width/2, height/2-20);
    } 
    else {
      text("MAYBE NEXT TIME ...", width/2, height/2-20);
    }

    replayButton.display();
    menuButton.display();
    exitButton.display();   

    popMatrix();
  }

  /*
  Handle clicking input
   */
  void mouseClicked() {
    if (replayButton.mouseOverButton() == true) {
      startGame(mapNameTemp, difficultyTemp);
    } 
    else if (menuButton.mouseOverButton() == true) {
      theMenu.changeScreen(1);
    } 
    else if (exitButton.mouseOverButton() == true) {
      exit();
    }
  }
}

