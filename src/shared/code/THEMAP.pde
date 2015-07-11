/*******************************************************
 
 Load and display a map-file - manage enemies & towers
 
 *******************************************************/

class THEMAP {

  /*
  Variables
   */

  /*XML & general variables*/

  XML xmlData; /*XML Object*/
  int[] mapSize; /*Global map size*/
  int difficulty;
  int tileSize; /*Global tile size*/
  PImage mapImage; /*The image of the map*/
  int[][][] tileMap; /*The 3rd level tilemap array*/
  int EMPTY = -1;  /*Is a tile empty?*/
  float centerY = 0; /*Used for scrolling on y-axis*/
  float centerX = 0; /*Used for scrolling on x-axis*/
  float zoom = 1;
  int mapWidth; /*Map width in px*/
  int mapHeight; /*Map height in px*/
  String mapPath;
  boolean defeated = false;
  boolean pause = false;
  PImage lightRay;
  boolean gameStarted = false;
  boolean showBuildAreas = false;
  boolean backToMenu = false;
  boolean backToMenuApply = false;

  /*Game Objects*/

  WAVES enemyWaves; /*The Waves*/
  WAYPOINTS theWayPoints; /*The Waypoints*/
  GUI theGui; /*The graphical user interface*/
  TOWERS theTowers; /*The Towers*/
  ANIMATIONS theAnimations; /*The Animations*/
  DISPLAY displayObject;
  ACTIONS theActions;
  CHARSETS theCharSets;


  /*
  Constructor
   */
  public THEMAP(String mapFile, float guiScale, float menuScale, int idifficulty) {

    mapPath = mapFile; 

    difficulty = idifficulty;

    theCharSets = new CHARSETS(this);

    theWayPoints = new WAYPOINTS(mapFile);    
    theTowers = new TOWERS(mapFile, this);

    mapImage = loadImage(mapFile + "/data/map.png");
    xmlData = loadXML(mapFile + "/maptree.xml");

    /*Set tileSize*/
    XML xmlTilesize = xmlData.getChild("tilesize");
    tileSize = xmlTilesize.getInt("s");

    /*Set mapSize*/
    XML xmlMapsize = xmlData.getChild("mapsize");
    mapSize = new int[2];
    mapSize[0] = xmlMapsize.getInt("w");
    mapSize[1] = xmlMapsize.getInt("h");

    /*Set tileMap*/
    tileMap = new int[mapSize[0]][mapSize[1]][2];
    XML[] xmlLevels = xmlData.getChildren("levels/level");        
    tileMap = unserializeMap(xmlLevels[2].getContent(), mapSize[0], mapSize[1]);

    /*Load & set waves*/
    enemyWaves = new WAVES(mapFile, theWayPoints, theGui, this);

    mapWidth = mapSize[0] * tileSize;
    mapHeight = mapSize[1] * tileSize;

    XML xmlGame = xmlData.getChild("game");
    /*INTBUG*/
    theGui = new GUI(int(xmlGame.getInt("startmoney")), xmlGame.getInt("lifes"), guiScale, menuScale, this);

    theAnimations = new ANIMATIONS();
    displayObject = new DISPLAY(this);    
    theActions = new ACTIONS(this);

    theActions.startMessage();    
    globalSpeed = 1f;

    if (highGraphicsQuality == true) { 
      lightRay = loadImage("ray1.png");
    }

    loadingMap = false;
    loadedMap = false;
  }

  /*
  Default constructor
   */
  public THEMAP() {
  }

  /*
  Check if we can build a tower
   */
  boolean canBuild(int x, int y) {

    int[] temp = pixelToTiles(x, y, tileSize);
    if (tileMap[temp[0]][temp[1]][0] == 1 || tileMap[temp[0]][temp[1]][0] == 3 || tileMap[temp[0]][temp[1]][0] == 4 || tileMap[temp[0]][temp[1]][0] == 5 || (mouseXp <= 85 && mouseXp >= 62 && mouseYp >= height-47 && mouseYp <= height-17)) {
      return false;
    } 
    else {
      return true;
    }
  }

  /*
  Display the map
   */
  void display() {

    if (antiAliasing == true) {
      smooth();
    } 
    else {
      noSmooth();
    }

    background(100);
    pushMatrix(); 

    /*Scroll*/
    translate(centerX, centerY);

    /*Zoom*/
    translate(width/2, height/2);
    scale(zoom);
    translate(-width/2, -height/2);      

    if (antiAliasing == true && globalPlatform == 1) {
      tint(255);
    }
    image(mapImage, 0, 0);
    noTint();

    /*Show build Areas*/
    if (showBuildAreas == true) {
      for (int i = 0; i < tileMap.length; i++) {
        for (int j = 0; j < tileMap[i].length; j++) {
          if (tileMap[i][j][0] != 1 && tileMap[i][j][0] != 3 && tileMap[i][j][0] != 4 && tileMap[i][j][0] != 5) {
            noStroke();
            fill(51, 153, 51, 120);
            rect(i*tileSize, j*tileSize, tileSize, tileSize, (int) (tileSize/4));
            noFill();
          }
        }
      }
    }

    displayObject.display();
    enemyWaves.displayGui();
    theTowers.displayGui();
    theTowers.displayArrow();
    if (lightRay != null) { 
      image(lightRay, 0, 0);
    }
    popMatrix();    


    theActions.displayActions();
    theGui.display();

    if (backToMenuApply == true) {
      showAfterMatch(false);
    }
  }

  /*
  Get the tileSize
   */
  int getTileSize() {
    return tileSize;
  }
}

