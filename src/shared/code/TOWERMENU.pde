/*******************************************************
 
 Base class for a tower menu
 
 *******************************************************/

class TOWERMENU {

  /*
   Variables
   */
  PFont font;
  THEMAP defenseMap;
  PImage[] towerIcons; /*Towericons in the build menu*/
  int bmRadius; /*Build menu radius*/
  float bmAngle; /*Angle between the icons in the build menu*/
  int[] bmPosition; /*Position of the build menu*/
  int iconSize = 30;
  int iconCount = 3;  
  int distanceFromBorderX = 0;
  int distanceFromBorderY = 0;
  TOWER tmActive;
  TOWERINFO tmInfo;

  /*
   Constructor
   */
  TOWERMENU(THEMAP idefenseMap, int id) {

    defenseMap = idefenseMap;
    bmPosition = pixelToTiles( inputHandler.winToMapX(mouseXp), inputHandler.winToMapY(mouseYp), defenseMap.tileSize);

    tmActive = defenseMap.theTowers.getTower(id);   
    tmActive.drawTowerRadius = true;
    towerIcons = new PImage[iconCount];
    towerIcons[0] = loadImage("repair_icon.png");
    towerIcons[1] = loadImage("update_icon.png");
    towerIcons[2] = loadImage("sell_icon.png");

    /*Set radius & angle*/
    bmRadius = (int) ((iconSize * 1.5 * iconCount) / (2 * PI));
    bmAngle = 2*PI/iconCount;
    if (bmRadius < (iconSize * 1.1)) { 
      bmRadius = (int) (iconSize * 1.1);
    }

    tmInfo = new TOWERINFO(tmActive.getDescription(), defenseMap);
    defenseMap.theAnimations.addAnimation(tmInfo, new int[][] { 
      new int[] { 
        1, 210, 0, 180, 0, 0
      }
    }
    );

    font = createFont("Arial", 48);

    if (bmPosition[0] == 0) {
      distanceFromBorderX = (bmRadius+(int) (iconSize/2))-(int) (defenseMap.tileSize/2);
    }
    if (bmPosition[0] == defenseMap.mapSize[0]-1) {
      distanceFromBorderX = -((bmRadius+(int) (iconSize/2))-(int) (defenseMap.tileSize/2));
    }
    if (bmPosition[1] == 0) {
      distanceFromBorderY = (bmRadius+(int) (iconSize/2))-(int) (defenseMap.tileSize/2);
    }
    if (bmPosition[1] == defenseMap.mapSize[1]-1) {
      distanceFromBorderY = -((bmRadius+(int) (iconSize/2))-(int) (defenseMap.tileSize/2));
    }
  }

  /*
Display
   */
  void display() {

    defenseMap.theAnimations.animate(this);

    pushMatrix();

    int x = inputHandler.mapToWinX(((bmPosition[0]+0.5)*defenseMap.tileSize) + distanceFromBorderX);
    int y = inputHandler.mapToWinY(((bmPosition[1]+0.5)*defenseMap.tileSize) + distanceFromBorderY);

    translate(-x*(defenseMap.theGui.menuScale-1), -y*(defenseMap.theGui.menuScale-1));
    scale(defenseMap.theGui.menuScale);

    for (int i=0; i<iconCount; i++) {
      imageMode(CENTER);
      if (antiAliasing == true && globalPlatform == 1) {
        tint(255);
      }
      if (i == 1 && ( tmActive.updates == 0 || tmActive.currentUpdate == tmActive.updates || defenseMap.theGui.money < tmActive.ucosts[tmActive.currentUpdate])) {
        tint(150, 200);
      }
      if (i == 0 && ( tmActive.health == tmActive.maxHealth || defenseMap.theGui.money < tmActive.getRepairCosts())) {
        tint(150, 200);
      }       
      image(towerIcons[i], x+(sin(bmAngle*i)*(bmRadius)), y+(cos(bmAngle*i)*(bmRadius)), iconSize, iconSize);
      imageMode(CORNER);
      noTint();
      textAlign(CENTER);
      textFont(font, 10);
      fill(0, 190);
      noStroke();
      rectMode(CENTER);
      rect(x+(sin(bmAngle*i)*(bmRadius)), y+(cos(bmAngle*i)*(bmRadius))+(iconSize/5), iconSize*0.8, iconSize/3);
      fill(255);
      int tempcosts = 0;
      switch(i) {
      case 0:
        if (tmActive.health != tmActive.maxHealth) {
          tempcosts = tmActive.getRepairCosts();
        }
        break;
      case 1:
        if (tmActive.updates > 0 && tmActive.currentUpdate != tmActive.updates) {
          tempcosts = tmActive.ucosts[tmActive.currentUpdate];
        }
        break;
      case 2:
        tempcosts = (int) (tmActive.costs*0.8);
      }
      text(tempcosts + " $", x+(sin(bmAngle*i)*(bmRadius)), y+(cos(bmAngle*i)*(bmRadius))+(iconSize/3)-1);
      textAlign(LEFT);
      imageMode(CORNER);
      rectMode(CORNER);
    }

    popMatrix();

    defenseMap.theAnimations.animateEnd(this);

    tmInfo.display();
  }

  /*
Close Menu
   */
  void closeMenu() {
    defenseMap.theAnimations.removeAnimation(tmActive);
    tmActive.drawTowerRadius = false;
  }

  /*
 Tower menu click
   */
  int mouseOver(int x, int y) {
    int returnVar = -1;
    for (int i=0; i<iconCount; i++) {
      float distance = dist(x, y, ((((bmPosition[0]+0.5)*defenseMap.tileSize)+distanceFromBorderX)*defenseMap.zoom)+(sin(bmAngle*i)*(bmRadius*defenseMap.theGui.menuScale)), ((((bmPosition[1]+0.5)*defenseMap.tileSize)*defenseMap.zoom)+distanceFromBorderY)+(cos(bmAngle*i)*(bmRadius*defenseMap.theGui.menuScale)));
      if ( distance <= int( int(iconSize/2) + 4) ) {
        returnVar = i;
        break;
      }
    }
    return returnVar;
  }
}

