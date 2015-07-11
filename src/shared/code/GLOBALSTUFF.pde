/*******************************************************
 
 Global stuff
 
 *******************************************************/

boolean developerMode = false;
double scaleFactor = 1;

/*
 Game Objects
 */
THEMAP defenseMap;
INPUT inputHandler;
ANIMATIONS theAnimations;
MENU theMenu;

/*
 Vars for loading a new map
 */
boolean loadingMap = false;
boolean loadedMap = false;
String mapNameTemp;
int difficultyTemp;
int mapCount = 0;

/*
 Game variables
 */
boolean showFps = false;
float globalSpeed = 1f;
PFont fpsFont;
boolean highGraphicsQuality = false;
boolean antiAliasing = false;
int mouseXp;
int mouseYp;

/*
Global Display
 */

void globalDisplay() {

  /*Display the main game objects*/
  if (defenseMap != null) { 
    defenseMap.display();
  }
  if (inputHandler != null) { 
    inputHandler.display();
  }      
  if (theMenu != null) { 
    theMenu.display();
  }

  /*Show a "Loading" sign when loading a new map*/
  if (loadingMap == true) {
    background(0);
    fill(255);
    textFont(fpsFont, 24);
    textAlign(CENTER);
    text("LOADING ...", width/2, (height/2)-10);      
    if (loadedMap == false && millis()-mapCount > 3000) {
      /*Initialise the new map*/
      loadedMap = true;
      defenseMap = new THEMAP(mapNameTemp, hudScale, menuScale, difficultyTemp);
      inputHandler = new INPUT(defenseMap);
    }
  }

  /*Show fps & screen size */   
  if (showFps == true) {
    textFont(fpsFont, 12);
    textAlign(RIGHT);
    fill(255);
    text(width + "x" + height + " @ " + int(frameRate)+" fps", width-2, 12);
    textAlign(LEFT);
  }
}



/*Unserialize a string into an array*/
int[][][] unserializeMap(String istring, int mapSizeX, int mapSizeY) {

  /*INTBUG*/
  mapSizeX = int(mapSizeX);
  mapSizeY = int(mapSizeY);

  String[] array_x = istring.split("_");
  int[][][] returnMe = new int[mapSizeX][mapSizeY][2];

  for (int i = 0; i < array_x.length; i++) {

    String[] array_y = array_x[i].split("#");

    for (int j = 0; j < array_y.length; j++) {

      String[] tiles = array_y[j].split(",");
      returnMe[i][j][0] = int(tiles[0]);
      returnMe[i][j][1] = int(tiles[1]);
    }
  } 
  return returnMe;
}


/*Convert pixel coords to tile coords*/
int[] pixelToTiles(int x, int y, int tileSize) {
  tileSize*=defenseMap.zoom;
  return new int[] {  
    (x-(x%tileSize))/tileSize, (y-(y%tileSize))/tileSize
  };
}

/*Start a new game and load a map*/
void startGame(String mapName, int difficulty) {
  loadingMap = true;
  theMenu = null;
  theAnimations = null;
  mapNameTemp = mapName;
  difficultyTemp = difficulty;  
  mapCount = millis();
}


/*Show the after match screen*/
void showAfterMatch(boolean wonTheGame) {
  defenseMap = null;
  inputHandler = null;
  theAnimations = new ANIMATIONS();
  theMenu = new MENU(2, wonTheGame);
}


/*List files in a directory*/
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } 
  else {
    return null;
  }
}
