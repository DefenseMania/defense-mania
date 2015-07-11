/*******************************************************
 
 Base class for all Menus
 
 *******************************************************/

class MENU {

  /*
 Vars
   */
  OPTIONSMENU theOptionsMenu;
  CREDITSMENU theCreditsMenu;
  MAINMENU theMainMenu;
  PLAYMENU thePlayMenu;
  AFTERMATCH theAfterMatchMenu;
  int screen = 0;
  int screenTemp = 0;
  boolean screenChanging = false;

  /*
 Constructor
   */
  MENU(int iscreen, boolean wonTheGame) {       
    theMainMenu = new MAINMENU();
    thePlayMenu = new PLAYMENU();
    theCreditsMenu = new CREDITSMENU();
    theOptionsMenu = new OPTIONSMENU();
    theAfterMatchMenu = new AFTERMATCH(wonTheGame);
    screen = iscreen;
  }


  /*
Display the menus
   */
  void display() {

    theAnimations.animate(this);

    if (screenChanging == true) {
      screenChanging = false;
      screen = screenTemp;
    }

    /*Show the right screen*/
    pushMatrix();
    translate(0, -(height*screen));

    background(0);

    /*Display the menus*/
    if (theMainMenu != null) { 
      theMainMenu.display();
    }
    if (theCreditsMenu != null) {
      theCreditsMenu.display();
    }
    if (thePlayMenu != null) { 
      thePlayMenu.display();
    }
    if (theOptionsMenu != null) { 
      theOptionsMenu.display();
    }
    if (theAfterMatchMenu != null) {
      theAfterMatchMenu.display();
    }   

    popMatrix();

    theAnimations.animateEnd(this);
  }

  /*
Some input-methods
   */
  void mouseClicked() {
    if (screen == -1) {
      theCreditsMenu.mouseClicked();
    }
    if (screen == 0) { 
      theMainMenu.mouseClicked();
    }
    if (screen == 1) { 
      thePlayMenu.mouseClicked();
    }
    if (screen == 2) {
      theAfterMatchMenu.mouseClicked();
    }
    if (screen == -2) {
      theOptionsMenu.mouseClicked();
    }
  }

  void scroll(float y) {
    if (thePlayMenu != null && screen == 1) {
      thePlayMenu.scroll(y);
    }
  }

  /*
Change the screen
   */
  void changeScreen(int i) {
    thePlayMenu.centerY = 0;
    int y1 = int( height*(i-screen) ); 
    screenTemp = i;
    screenChanging = true;
    theAnimations.addAnimation(this, new int[][] { 
      new int[] {
        2, y1, 0, 400, 0, 0
      }
    }
    );
  }
}

