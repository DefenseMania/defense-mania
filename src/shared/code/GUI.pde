/*******************************************************
 
 Display the graphical user interface & handle game vars
 
 *******************************************************/

class GUI {

  /*
  Variables
   */
  PImage moneyImg;
  PImage lifeImg;
  PImage hudBottom;
  PImage hudTop;
  PImage hudPlay;
  PImage hudBuild;
  PImage hudMenu;
  BUTTON yesButton;
  BUTTON noButton;
  PFont guiFont;
  int money;
  int lifes;
  THEMAP defenseMap;
  float guiScale = 1.0f;
  float menuScale = 1.0f;

  /*
  Constructor
   */
  GUI(int startmoney, int startlifes, float iguiScale, float imenuScale, THEMAP idefenseMap) {
    money = startmoney;
    lifes = startlifes;
    guiScale = iguiScale;
    menuScale = imenuScale;
    hudBottom = loadImage("hud_bottom.png");
    hudTop = loadImage("hud_top.png");
    moneyImg = loadImage("money.png");
    lifeImg = loadImage("life.png");
    hudPlay = loadImage("hud_pause.png");
    hudBuild = loadImage("build.png");
    guiFont = createFont("Arial", 48);
    hudMenu = loadImage("menu.png");
    defenseMap = idefenseMap;
    yesButton = new BUTTON(0, "YES", width/2-120, height/2+40, 60, 26);
    noButton = new BUTTON(0, "NO", width/2+60, height/2+40, 60, 26);
  }

  /*
  Display
   */
  void display() {

    pushMatrix();

    /*Scale the top hud-element (for android your need a bigger hud)*/
    scale(guiScale);

    /*Display the top hud-element*/
    if (antiAliasing == true && globalPlatform == 1) {
      tint(255);
    }
    image(hudTop, 0, 0);
    image(moneyImg, 8, 9);
    noTint();
    textFont(guiFont, 15);
    fill(0, 180);
    text(money, 27, 24);
    fill(#fff8c8);
    text(money, 26, 23);
    if (antiAliasing == true && globalPlatform == 1) {
      tint(255);
    }
    image(lifeImg, 70, 11);
    noTint();
    fill(0, 180);
    text(lifes, 89, 24);
    fill(#fff8c8);
    text(lifes, 88, 23);    
    popMatrix();

    pushMatrix();

    /*Scale the button hud-element (for android you need a bigger hud)*/
    translate(-((width-400)*(guiScale-1))-((400*guiScale)-400), -((height-50)*(guiScale-1))-((50*guiScale)-50));
    scale(guiScale);    

    /*Display the button hud-element*/
    imageMode(CORNER);
    if (antiAliasing == true && globalPlatform == 1) {
      tint(255);
    }
    image(hudBottom, width-400, height-50);
    noTint();    
    textFont(guiFont, 14);
    textAlign(LEFT);
    fill(0, 180);
    text("Wave " + (defenseMap.enemyWaves.currentWave+1) + " of " + defenseMap.enemyWaves.theWaves.length + " - next wave:", width-357, height-7);
    fill(#fff8c8);
    text("Wave " + (defenseMap.enemyWaves.currentWave+1) + " of " + defenseMap.enemyWaves.theWaves.length + " - next wave:", width-358, height-8);
    textAlign(LEFT);    
    defenseMap.enemyWaves.nextEnemies(width-165, height-30);    

    popMatrix();

    if (defenseMap.backToMenu == true) {
      fill(0, 180);
      noStroke();
      rectMode(CENTER);
      rect(width/2, height/2, width/3, height/3, 20);
      textFont(guiFont, 18);
      fill(255);
      textAlign(CENTER);
      text("Do you really want to quit\nand go back to the menu?", width/2, height/2-40);
      yesButton.display(); 
      noButton.display();
    }

    pushMatrix();

    translate(-((13*guiScale)-13), -(((height-13)*guiScale)-(height-13)));
    scale(guiScale);


    if (antiAliasing == true && globalPlatform == 1) {
      tint(255);
    }

    /*Display the Play/Pause button*/
    image(hudPlay, 13, height-49);

    /*Display the build Button*/
    image(hudBuild, 65, height-47);

    /*Display the back-to-menu Button*/
    image(hudMenu, 105, height-47);

    noTint();

    popMatrix();
  }

  /*
  Enemy got killed
   */
  void enemyKilled(int plusmoney) {
    /*INTBUG*/
    money += int(plusmoney);
  }

  /*
  Enemy reached the endpoint
   */
  void enemyReachedEnd() {
    lifes--;
    if (lifes == 0) {
      defenseMap.theActions.loseGame();
    }
  }
}

