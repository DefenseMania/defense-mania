/*******************************************************
 
 Base class for the play & choose map - menu
 
 *******************************************************/

class PLAYMENU {

  /*
 Variables
   */
  BUTTON easyButton;
  BUTTON normalButton;
  BUTTON hardButton;
  BUTTON backButton;
  BUTTON playGameButton;
  BUTTON[] mapButtons;
  ArrayList customMapButtons;
  float buttonDistance = ((width-(110*3))/4);
  int hardness = 2;
  PFont menuFont;
  XML xmlData;
  String[][][] theMaps;
  ArrayList customMaps;
  PImage[] theMapIcons;
  ArrayList customMapIcons;
  int posTopMaps = 120;
  int mapsWidth = 400;
  int mapPicked = -1;
  int customMapPicked = -1;
  int centerY = 0;

  /*
 Constructor
   */
  PLAYMENU() {

    /*Initiate buttons & vars*/
    backButton = new BUTTON(0, "BACK", 65, height-65, 110, 26);
    playGameButton = new BUTTON(0, "PLAY", width-65-110, height-65, 110, 26);
    easyButton = new BUTTON(1, "EASY", int(buttonDistance), 40, 110, 26);
    normalButton = new BUTTON(1, "NORMAL", int(buttonDistance*2)+110, 40, 110, 26);
    hardButton = new BUTTON(1, "HARD", int(buttonDistance*3)+220, 40, 110, 26);
    normalButton.isActive = true;
    playGameButton.isLocked = true;
    menuFont = createFont("bitterregular.ttf", 48);
    customMaps = new ArrayList();
    customMapIcons = new ArrayList();
    customMapButtons = new ArrayList();

    /*Load data from XML*/
    xmlData = loadXML("maps.xml");  
    XML[] xmlMaps = xmlData.getChildren("standardmaps/map");

    /*Set data from XML*/
    theMaps = new String[2][xmlMaps.length][4];
    mapButtons = new BUTTON[xmlMaps.length];
    theMapIcons = new PImage[xmlMaps.length];
    for (int i = 0; i < xmlMaps.length; i++) {
      theMaps[0][i][0] = xmlMaps[i].getString("name");
      theMaps[0][i][1] = xmlMaps[i].getString("url");
      theMaps[0][i][2] = xmlMaps[i].getString("img");
      if (theMaps[0][i][2] != "") { 
        theMapIcons[i] = loadImage("maps/" + theMaps[0][i][1] + "/" + theMaps[0][i][2]);
      } 
      theMaps[0][i][3] = xmlMaps[i].getString("size"); 
      mapButtons[i] = new BUTTON(3, theMaps[0][i][0], (width/2)-(mapsWidth/2), posTopMaps+((i)*60)+30, 300, 26);
    }

    /*Set custom maps*/
    int p = 0;
    if (globalPlatform == 0 && developerMode == true) {
      File customMapPath = new File(sketchPath("") + "custom-maps/");
      if (customMapPath.exists()) {
        File[] files = listFiles(sketchPath("") + "custom-maps");
        for (int i = 0; i < files.length; i++) {
          File f = files[i];
          File maptree = new File(sketchPath("") + "custom-maps/" + f.getName() + "/maptree.xml");
          if (f.isDirectory() && maptree.exists()) {   
            xmlData = loadXML(sketchPath("") + "custom-maps/" + f.getName() + "/maptree.xml"); 
            XML xmlMap = xmlData.getChild("mapsize");
            String[] temp = new String[4];
            temp[0] = f.getName();
            temp[1] = f.getName();
            temp[2] = "map_logo.png";
            temp[3] = xmlMap.getInt("w") + " x " +  xmlMap.getInt("h");
            customMaps.add(temp);
            customMapButtons.add( new BUTTON(3, temp[0], (width/2)-(mapsWidth/2), posTopMaps+(mapButtons.length*60)+80+((p)*60)+30, 300, 26) );
            customMapIcons.add( /*loadImage(sketchPath("") + "custom-maps/" + f.getName() + "/maplogo.png") );*/ "test" );
            p++;
          }
        }
      }
    }

    mapButtons[0].isActive = true;
    mapPicked = 0;
    playGameButton.isLocked = false;
  }

  /*
 Display the menu
   */
  void display() {

    pushMatrix();   

    /*Move the menu out of the screen*/
    translate(0, height);

    pushMatrix();

    /*Display the available maps*/
    translate(0, centerY);  
    fill(255, 190);
    textFont(menuFont, 18);
    text("Standard maps", (width/2)-(mapsWidth/2), posTopMaps-5);
    stroke(#f8ddc2);
    line((width/2)-(mapsWidth/2), posTopMaps, (width/2)+(mapsWidth/2), posTopMaps);
    stroke(#251002);
    line((width/2)-(mapsWidth/2), posTopMaps+1, (width/2)+(mapsWidth/2), posTopMaps+1);  

    for (int i = 0; i < mapButtons.length; i++) {
      mapButtons[i].display();
      if (theMaps[0][i][2] != "") { 
        image(theMapIcons[i], (width/2)-(mapsWidth/2), posTopMaps+((i)*60)+30);
      }
      textFont(menuFont, 12);
      textAlign(CENTER);
      text(theMaps[0][i][3], (width/2)-(mapsWidth/2)+150, posTopMaps+((i)*60)+70);
    }

    /*Display the custom maps*/
    if (globalPlatform == 0 && developerMode == true) {
    fill(255, 190);
    textFont(menuFont, 18);
    textAlign(LEFT);
    text("Custom maps", (width/2)-(mapsWidth/2), posTopMaps-5+(mapButtons.length*60)+80);
    stroke(#f8ddc2);
    line((width/2)-(mapsWidth/2), posTopMaps+(mapButtons.length*60)+80, (width/2)+(mapsWidth/2), posTopMaps+(mapButtons.length*60)+80);
    stroke(#251002);
    line((width/2)-(mapsWidth/2), posTopMaps+(mapButtons.length*60)+81, (width/2)+(mapsWidth/2), posTopMaps+(mapButtons.length*60)+81);   

      if (customMapButtons.size() == 0) {
        text("no maps availabe", (width/2)-(mapsWidth/2), posTopMaps-5+(mapButtons.length*60)+120);
      } 
      else {
        for (int i = 0; i < customMapButtons.size(); i++) {
          BUTTON tempButton = (BUTTON) customMapButtons.get(i);
          tempButton.display();

          //PImage tempImage = (PImage) customMapIcons.get(i);
          //image(tempImage, (width/2)-(mapsWidth/2), posTopMaps+(mapButtons.length*60)+80+((i)*60)+30);

          String[] tempMap = (String[]) customMaps.get(i);

          textFont(menuFont, 12);
          textAlign(CENTER);
          text(tempMap[3], (width/2)-(mapsWidth/2)+150, posTopMaps+(mapButtons.length*60)+80+((i)*60)+70);
        }
      }
    }

    popMatrix();  

    /*Display the buttons*/
    fill(0);
    noStroke();
    easyButton.display();
    normalButton.display();
    hardButton.display();
    backButton.display();
    playGameButton.display();

    popMatrix();
  } 

  /*
Scroll
   */

  void scroll(float y) {
    centerY += (int) y;
    if (centerY > 0) {
      centerY = 0;
    }

    for (int i = 0; i < mapButtons.length; i++) {
      mapButtons[i].scrollOffset = centerY;
    }
    for (int i = 0; i < customMapButtons.size(); i++) {
      BUTTON temp = (BUTTON) customMapButtons.get(i);
      temp.scrollOffset = centerY;
    }
  }

  /*
Handling mouse input
   */
  void mouseClicked() {
    if (playGameButton.mouseOverButton() == true && playGameButton.isLocked == false) {
      if (customMapPicked != -1) {
        String[] temp = (String[]) customMaps.get(customMapPicked);
        startGame(sketchPath("") + "custom-maps/" + temp[1], hardness);
      } 
      else {
        startGame("maps/" + theMaps[0][mapPicked][1], hardness);
      }
    } 
    else if (easyButton.mouseOverButton() == true) {
      normalButton.isActive = false;
      hardButton.isActive = false;
      easyButton.isActive = true;
      hardness = 1;
    } 
    else if (normalButton.mouseOverButton() == true) {
      normalButton.isActive = true;
      hardButton.isActive = false;
      easyButton.isActive = false;
      hardness = 2;
    } 
    else if (hardButton.mouseOverButton() == true) {
      normalButton.isActive = false;
      hardButton.isActive = true;
      easyButton.isActive = false;
      hardness = 3;
    } 
    else if (backButton.mouseOverButton() == true) {
      theMenu.changeScreen(0);
    } 
    else {

      for (int i = 0; i < mapButtons.length; i++) {
        if (mapButtons[i].mouseOverButton() == true) {
          if (mapPicked == -1) {
            playGameButton.isLocked = false;
          }
          for (int j = 0; j < customMapButtons.size(); j++) {
            BUTTON temp2 = (BUTTON) customMapButtons.get(j);
            temp2.isActive = false;
          }
          for (int j = 0; j < mapButtons.length; j++) {
            mapButtons[j].isActive = false;
          }
          mapButtons[i].isActive = true;
          mapPicked = i;
          customMapPicked = -1;
          break;
        }
      }

      for (int i = 0; i < customMapButtons.size(); i++) {      
        BUTTON temp = (BUTTON) customMapButtons.get(i);
        if (temp.mouseOverButton() == true) {
          for (int j = 0; j < mapButtons.length; j++) {
            mapButtons[j].isActive = false;
          }
          for (int j = 0; j < customMapButtons.size(); j++) {
            BUTTON temp2 = (BUTTON) customMapButtons.get(j);
            temp2.isActive = false;
          }
          temp.isActive = true;
          customMapPicked = i;
          break;
        }
      }
    }
  }
}

