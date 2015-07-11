/*******************************************************
 
 Input class for handling input & displaying build- and towermenus
 
 *******************************************************/

class INPUT {

  /*
  Variables
   */
  THEMAP defenseMap;
  BUILDMENU buildMenu;
  TOWERMENU towerMenu;
  boolean justPaused = false;

  /*
  Constructor
   */
  INPUT(THEMAP idefenseMap) {   
    defenseMap = idefenseMap;
  }

  /*
 Zoom
   */
  void zoom(float z) {
    defenseMap.zoom += z;
    if (defenseMap.zoom < 1) { 
      defenseMap.zoom = 1;
    }
    if (defenseMap.zoom > 1.5) { 
      defenseMap.zoom = 1.5;
    }
    checkBorders();
  }

  /*
 Scroll
   */
  void scroll(float x, float y) {
    defenseMap.centerX+=x;
    defenseMap.centerY+=y;
    checkBorders();
  }

  /*
Check Border for scrolling and zooming
   */
  void checkBorders() {
    if (defenseMap.centerX > (width/2)*(defenseMap.zoom-1)) { 
      defenseMap.centerX = (width/2)*(defenseMap.zoom-1);
    }
    if (defenseMap.centerX < (width-(defenseMap.mapWidth*defenseMap.zoom))+(width/2)*(defenseMap.zoom-1)) { 
      defenseMap.centerX = (width-(defenseMap.mapWidth*defenseMap.zoom))+(width/2)*(defenseMap.zoom-1);
    }
    if (defenseMap.centerY > (height/2)*(defenseMap.zoom-1)) { 
      defenseMap.centerY = (height/2)*(defenseMap.zoom-1);
    }
    if (defenseMap.centerY < (height-(defenseMap.mapHeight*defenseMap.zoom))+(height/2)*(defenseMap.zoom-1)) { 
      defenseMap.centerY = (height-(defenseMap.mapHeight*defenseMap.zoom))+(height/2)*(defenseMap.zoom-1);
    }
  }

  /*
Coords calculation between window & map in zooming state
   */
  int mapToWinX(float x) {
    return (int) (((x-(width/2))*defenseMap.zoom)+(width/2)) ;
  }
  int mapToWinY(float y) {
    return (int) (((y-(height/2))*defenseMap.zoom)+(height/2));
  }
  int winToMapX(float x) {
    return (int) (x+((width/2)*defenseMap.zoom)-(width/2)-defenseMap.centerX);
  }
  int winToMapY(float y) {
    return (int) (y+((height/2)*defenseMap.zoom)-(height/2)-defenseMap.centerY);
  }

  /*
 Mouse click
   */
  void mouseClick() {
    
    /*Check if the click was on the play/pause button*/
    if (mouseXp <= 49*hudScale && mouseXp >= 13 && mouseYp >= height-(49*hudScale) && mouseYp <= height-13) {
      if (defenseMap.pause == false) {
        defenseMap.theGui.hudPlay = loadImage("hud_play.png");
        globalSpeed = 0f;
        defenseMap.pause = true;
      } 
      else {
        defenseMap.theGui.hudPlay = loadImage("hud_pause.png");
        globalSpeed = 1f;
        defenseMap.pause = false;
        justPaused = true;
      }
    } 

    /*Check if the click was on the build button*/
    if (mouseXp <= 85*hudScale && mouseXp >= 62*hudScale && mouseYp >= height-(47*hudScale) && mouseYp <= height-13) {
      if (defenseMap.showBuildAreas == true) {
        defenseMap.showBuildAreas= false;
      } 
      else {
        defenseMap.showBuildAreas = true;
      }
    } 
    else {
      defenseMap.showBuildAreas= false;
    }

    /*Check if the click was on the menu button*/
    if (mouseXp <= 135*hudScale && mouseXp >= 105*hudScale && mouseYp >= height-(47*hudScale) && mouseYp <= height-13) {
      globalSpeed = 0f;
      defenseMap.pause = true;
      defenseMap.backToMenu = true;
    }

    /*Check if one of the buttons were clicked*/
    if (defenseMap.backToMenu == true) {
      if (defenseMap.theGui.yesButton.mouseOverButton() == true) {
        defenseMap.backToMenuApply = true;
      } 
      else if (defenseMap.theGui.noButton.mouseOverButton() == true) {
        defenseMap.backToMenu = false;
        globalSpeed = 1f;
        defenseMap.pause = false;
        justPaused = true;
      }
    }

    /*Proceed if the game is running and not paused*/
    if (defenseMap.defeated == false && defenseMap.pause == false && justPaused == false) {

      /*Check if there's a tower*/
      int j = defenseMap.theTowers.isTower(winToMapX(mouseXp), winToMapY(mouseYp)); 

      if (buildMenu != null) {

        /*Check if there's the build menu open and build a tower*/
        int i = buildMenu.mouseOver(winToMapX(mouseXp), winToMapY(mouseYp));
        if (i != -1) { 
          defenseMap.theTowers.addTower(i, buildMenu.bmPosition[0], buildMenu.bmPosition[1]); 
          buildMenu = null;
        }
        else { 
          buildMenu = null;
        }
      } 
      else {

        /*Close the tower menu*/
        if (towerMenu != null) {

          /*Check if there's a tower menu open and update,sell,repair the tower*/
          int k = towerMenu.mouseOver( winToMapX(mouseXp), winToMapY(mouseYp));
          if (k != -1) {
            switch(k) {
            case 2: /*Sell Tower*/
              defenseMap.theTowers.sellTower(towerMenu.tmActive);
              towerMenu.closeMenu();
              towerMenu = null; 
              break;
            case 0: /*Repair Tower*/
              towerMenu.tmActive.repairTower();
              break; 
            case 1: /*Update Tower*/
              towerMenu.tmActive.updateTower();
              towerMenu.tmInfo.updateDesc(towerMenu.tmActive.getDescription());
              break;
            }
          } 
          else {       
            towerMenu.closeMenu();
            towerMenu = null;
          }
        } 
        else if (j != -1) {
          /*Check if there's a tower and open tower menu*/
          towerMenu = new TOWERMENU(defenseMap, j);
          defenseMap.theAnimations.addAnimation(towerMenu, new int[][] { 
            new int[] { 
              1, mapToWinX((towerMenu.bmPosition[0]+0.5f)*defenseMap.tileSize), 0, 180, 0, 0
            }
            , new int[] {
              2, mapToWinY((towerMenu.bmPosition[1]+0.5f)*defenseMap.tileSize), 0, 180, 0, 0
            }
            , new int[] { 
              0, 0, 1, 180, 0, 0
            }
          }
          );       
          if (globalPlatform != 2) {
            defenseMap.theAnimations.addAnimation(defenseMap.theTowers.getTower(j), new int[][] { 
              new int[] { 
                6, 255, 0, 500, 0, 1
              }
            }          
            );
          }
          /*Open the build Menu*/
        } 
        else if (defenseMap.canBuild( winToMapX(mouseXp), winToMapY(mouseYp)) == true) {
          buildMenu = new BUILDMENU(defenseMap);
          defenseMap.theAnimations.addAnimation(buildMenu, new int[][] { 
            new int[] { 
              1, mapToWinX((buildMenu.bmPosition[0]+0.5f)*defenseMap.tileSize), 0, 180, 0, 0
            }
            , new int[] {
              2, mapToWinY((buildMenu.bmPosition[1]+0.5f)*defenseMap.tileSize), 0, 180, 0, 0
            }
            , new int[] { 
              0, 0, 1, 180, 0, 0
            }
          }
          );
        }
      }
    }

    justPaused = false;
  }


  /*
 Display the build- and towermenu
   */
  void display() {

    pushMatrix();
    translate(defenseMap.centerX, defenseMap.centerY);

    if (buildMenu != null) { 
      buildMenu.display();
    }
    if (towerMenu != null) { 
      towerMenu.display();
    }

    popMatrix();
  }
}

