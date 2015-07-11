/*******************************************************
 
 Base class for a build menu
 
 *******************************************************/

class BUILDMENU {

  /*
   Variables
   */
  THEMAP defenseMap;
  PFont font;
  PImage[] towerIcons;
  int bmRadius;
  float bmAngle;
  int[] bmPosition;
  int iconSize;
  int iconCount;  
  int distanceFromBorderX = 0;
  int distanceFromBorderY = 0; 

  /*
   Constructor
   */
  BUILDMENU(THEMAP idefenseMap) {

    /*Initiate vars & images*/
    font = createFont("Arial", 48);     
    defenseMap = idefenseMap;
    bmPosition = pixelToTiles(inputHandler.winToMapX(mouseXp), inputHandler.winToMapY(mouseYp), defenseMap.tileSize);  
    iconCount = defenseMap.theTowers.towerTypes.length;
    iconSize = defenseMap.theTowers.towerTypes[0].towerIconSize;
    towerIcons = new PImage[iconCount];
    for (int i=0; i<iconCount; i++) {
      towerIcons[i] = loadImage(defenseMap.mapPath + "/data/" + defenseMap.theTowers.towerTypes[i].towerIcon);
    }       

    /*Set radius & angle*/
    bmRadius = (int) ((iconSize * 1.5 * iconCount) / (2 * PI));
    bmAngle = 2*PI/iconCount;
    if (bmRadius < (iconSize * 0.6)) { 
      bmRadius = (int) (iconSize * 0.6);
    }

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

    /*Calculate position*/
    int x = inputHandler.mapToWinX(((bmPosition[0]+0.5)*defenseMap.tileSize) + distanceFromBorderX);
    int y = inputHandler.mapToWinY(((bmPosition[1]+0.5)*defenseMap.tileSize) + distanceFromBorderY);

    /*Scale the menu (for android we need a bigger menu)*/
    translate(-x*(defenseMap.theGui.menuScale-1), -y*(defenseMap.theGui.menuScale-1));
    scale(defenseMap.theGui.menuScale);

    /*Draw the circle and the icons*/
    ellipseMode(CENTER); 
    noFill(); 
    stroke(204, 255, 153, 200); 
    ellipse(x, y, (bmRadius*2), (bmRadius*2)); 
    ellipseMode(CORNER);
    for (int i=0; i<iconCount; i++) {
      imageMode(CENTER);
      if (antiAliasing == true && globalPlatform == 1) {
        tint(255);
      }
      if (defenseMap.theGui.money < defenseMap.theTowers.towerTypes[i].costs) { 
        tint(150, 200);
      }
      image(towerIcons[i], x+(sin(bmAngle*i)*(bmRadius)), y+(cos(bmAngle*i)*(bmRadius)), iconSize, iconSize);
      textAlign(CENTER);
      textFont(font, 10);
      fill(0, 190);
      noStroke();
      rectMode(CENTER);
      rect(x+(sin(bmAngle*i)*(bmRadius)), y+(cos(bmAngle*i)*(bmRadius))+(iconSize/5)+2, iconSize*0.8, iconSize/3);
      fill(255);
      text(defenseMap.theTowers.towerTypes[i].costs + " $", x+(sin(bmAngle*i)*(bmRadius)), y+(cos(bmAngle*i)*(bmRadius))+(iconSize/3)+1);
      textAlign(LEFT);
      imageMode(CORNER);
      rectMode(CORNER);
      noTint();
    }

    popMatrix();

    defenseMap.theAnimations.animateEnd(this);
  }

  /*
 Build menu click
   */
  int mouseOver(int x, int y) {
    int returnVar = -1;
    for (int i=0; i<iconCount; i++) {
      float distance = dist(x, y, ((((bmPosition[0]+0.5)*defenseMap.tileSize)+distanceFromBorderX)*defenseMap.zoom)+(sin(bmAngle*i)*(bmRadius*defenseMap.theGui.menuScale)), ((((bmPosition[1]+0.5)*defenseMap.tileSize)+distanceFromBorderY)*defenseMap.zoom)+(cos(bmAngle*i)*(bmRadius*defenseMap.theGui.menuScale)));
      if ( distance <= ((int) (iconSize/2) + 4)) {
        returnVar = i;
        break;
      }
    }   
    return returnVar;
  }
}

