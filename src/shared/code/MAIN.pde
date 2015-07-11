/*******************************************************
 
 Base class for the main menu
 
 *******************************************************/

class MAINMENU {

  /*
  Variables
   */
  PImage backgroundImage;
  BUTTON playButton;
  BUTTON creditsButton;
  BUTTON exitButton;
  BUTTON optionsButton;
  float buttonDistance = ((width-(130*4))/5);

  /*
  Constructor
   */
  MAINMENU() {   

    /*Initiate the buttons and images */
    backgroundImage = loadImage("logo_dm.png");
    playButton = new BUTTON(0, "PLAY", int(buttonDistance), height-65, 130, 26);
    creditsButton = new BUTTON(0, "CREDITS", int(buttonDistance*2)+130, height-65, 130, 26);
    if(globalPlatform != 2) {
      exitButton = new BUTTON(0, "EXIT", int(buttonDistance*4)+(130*3), height-65, 130, 26);
    }
    optionsButton = new BUTTON(0, "OPTIONS", int(buttonDistance*3)+(130*2), height-65, 130, 26);

    /*Add the animations for the buttons*/
    theAnimations.addAnimation(playButton, new int[][] { 
      new int[] {
        2, 200, 0, 800, 1000, 0
      }
    }
    );
    theAnimations.addAnimation(creditsButton, new int[][] { 
      new int[] {
        2, 200, 0, 800, 1100, 0
      }
    }
    );
    if(globalPlatform != 2) {
      theAnimations.addAnimation(exitButton, new int[][] { 
        new int[] {
          2, 200, 0, 800, 1300, 0
        }
      }
      );
    }
    theAnimations.addAnimation(optionsButton, new int[][] { 
      new int[] {
        2, 200, 0, 800, 1200, 0
      }
    }
    );
    theAnimations.addAnimation(this, new int[][] { 
      new int[] {
        3, 0, 255, 1000, 0, 0
      }
    }
    );
  }


  /*
  Display the menu
   */
  void display() {   
    theAnimations.animate(this); 

    imageMode(CENTER);
    image(backgroundImage, width/2, (backgroundImage.height/2)+40);
    playButton.display();
    if (globalPlatform != 2) {
      exitButton.display();
    }
    creditsButton.display();
    optionsButton.display();

    theAnimations.animateEnd(this);
  }

  /*
  Handle clicking input
   */
  void mouseClicked() {
    if (playButton.mouseOverButton() == true) {
      theMenu.changeScreen(1);
    }    
    else if (creditsButton.mouseOverButton() == true) {
      theMenu.changeScreen(-1);
    } 
    else if (optionsButton.mouseOverButton() == true) {
      theMenu.changeScreen(-2);
    }
    else if (globalPlatform != 2) {
      if (exitButton.mouseOverButton() == true) {
        exit();
      }        
    } 
  }
}

