/*******************************************************
 
 Class for managin actions like starting & ending the game
 
 *******************************************************/

class ACTIONS {

  /*
 Variables
   */
  THEMAP defenseMap;
  int timer;
  int action = 0;
  PFont guiFont;
  boolean[] startGameBool;

  /*
 Constructor
   */
  ACTIONS(THEMAP idefenseMap) {
    defenseMap = idefenseMap;
    guiFont = createFont("Arial Black", 72);
    startGameBool = new boolean[4];
  }


  /*
Show start message
   */

  void startMessage() {
    timer = millis();
    action = 5;
    defenseMap.theAnimations.addAnimation(this, new int[][] { 
      new int[] { 
        1, width/2, 0, 800, 500, 0
      }
      , new int[] { 
        2, height/2, 0, 800, 500, 0
      }
      , new int[] { 
        0, 0, 1, 800, 500, 0
      }
    }
    );
  }

  /*
Display the start message
   */
  void displayStartMessage() {
    defenseMap.theAnimations.animate(this);  
    textAlign(CENTER);
    textFont(guiFont, 24);
    fill(0);
    text("The game will start when\nyou build the first tower", (width/2)-1, (height/2)-1);
    fill(255);
    text("The game will start when\nyou build the first tower", width/2, height/2);  
    textAlign(LEFT);
    defenseMap.theAnimations.animateEnd(this);
  }

  /*
Start the game
   */
  void startGame() {
    defenseMap.gameStarted = true;
    timer = millis();
    action = 1;
    defenseMap.theAnimations.addAnimation(this, new int[][] { 
      new int[] { 
        1, width/2, 0, 800, 1000, 0
      }
      , new int[] { 
        2, height/2, 0, 800, 1000, 0
      }
      , new int[] { 
        0, 0, 1, 800, 1000, 0
      }
    }
    );
  }

  /*
Play text animations at the beginning of the game
   */
  void startGameDisplay() {  

    String theText = "";
    textAlign(CENTER);
    textFont(guiFont, 64);

    if (millis()-timer <= 3000) {          
      textFont(guiFont, 48);
      theText = "Prepare!";
    } 
    else if (millis()-timer <= 4000) {
      if (startGameBool[0] == false) { 
        defenseMap.theAnimations.addAnimation(this, new int[][] { 
          new int[] { 
            1, width/2, 0, 200, 0, 0
          }
          , new int[] { 
            2, height/2, 0, 200, 0, 0
          }
          , new int[] { 
            0, 0, 1, 200, 0, 0
          }
        }
        ); 
        startGameBool[0] = true;
      }
      theText = "3";
    } 
    else if (millis()-timer <= 5000) {
      if (startGameBool[1] == false) { 
        defenseMap.theAnimations.addAnimation(this, new int[][] { 
          new int[] { 
            1, width/2, 0, 200, 0, 0
          }
          , new int[] { 
            2, height/2, 0, 200, 0, 0
          }
          , new int[] { 
            0, 0, 1, 200, 0, 0
          }
        }
        ); 
        startGameBool[1] = true;
      }
      theText = "2";
    } 
    else if (millis()-timer <= 6000) {
      if (startGameBool[2] == false) { 
        defenseMap.theAnimations.addAnimation(this, new int[][] { 
          new int[] { 
            1, width/2, 0, 200, 0, 0
          }
          , new int[] { 
            2, height/2, 0, 200, 0, 0
          }
          , new int[] { 
            0, 0, 1, 200, 0, 0
          }
        }
        ); 
        startGameBool[2] = true;
      }
      theText = "1";
    } 
    else {
      if (startGameBool[3] == false) { 
        defenseMap.theAnimations.addAnimation(this, new int[][] { 
          new int[] { 
            1, width/2, 0, 200, 0, 0
          }
          , new int[] { 
            2, height/2, 0, 200, 0, 0
          }
          , new int[] { 
            0, 0, 1, 200, 0, 0
          }
        }
        ); 
        startGameBool[3] = true;
      }
      textFont(guiFont, 72);
      theText = "GO!";
    }

    defenseMap.theAnimations.animate(this);
    fill(0);
    text(theText, (width/2)-2, (height/2)-2);
    fill(255);
    text(theText, width/2, height/2);  
    textAlign(LEFT); 
    defenseMap.theAnimations.animateEnd(this);
  }

  /*
Wait 2 seconds and start the next wave
   */
  void continueNextWave() {
    timer = millis();
    action = 2;
  }

  /*
Won the game: pause it and stop actions
   */
  void wonGame() {
    timer = millis();
    action = 3; 
    globalSpeed = 0f;
    defenseMap.defeated = true;
  }

  /*
Won the game: show a text
   */
  void displayWonGame() {  
    textAlign(CENTER);
    textFont(guiFont, 64);
    fill(0);
    text("Victory!", (width/2)-2, (height/2)-2);
    fill(255);
    text("Victory!", width/2, height/2);  
    textAlign(LEFT);
  }

  /*
Lose the game: pause it and stop actions
   */
  void loseGame() {  
    timer = millis();
    action = 4;
    defenseMap.defeated = true;
    globalSpeed = 0f;
  }

  /*
Lose the game: show text animations
   */
  void displayLoseGame() {
    textAlign(CENTER);
    textFont(guiFont, 64);
    fill(0);
    text("Defeated!", (width/2)-2, (height/2)-2);
    fill(255);
    text("Defeated!", width/2, height/2);  
    textAlign(LEFT);
  }

  /*
Main call method
   */
  void displayActions() {

    switch(action) {

    case 0: 
      break;

    case 1: /*Start Game*/
      if (millis()-timer <= 8000) {          
        startGameDisplay();
      } 
      else {
        defenseMap.enemyWaves.nextWave();
        action = 0;
        startGameBool = new boolean[4];
      }
      break;

    case 2: /*Next Wave*/
      if (millis()-timer >= 2000) {          
        defenseMap.enemyWaves.nextWave();
        action = 0;
      }
      break;

    case 3: /*Won the Game*/
      if (millis()-timer <= 3000) {
        displayWonGame();
      } 
      else {
        action = 0;
        showAfterMatch(true);
      }
      break;

    case 4: /*Lose the Game*/
      if (millis()-timer <= 3000) {
        displayLoseGame();
      } 
      else {
        action = 0;
        showAfterMatch(false);
      }
      break;

    case 5:
      if (millis()-timer <= 5000) {
        displayStartMessage();
      }
      break;
    }
  }
}

