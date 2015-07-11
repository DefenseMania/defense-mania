/*******************************************************
 
 Base class for managing enemies in a wave
 
 *******************************************************/

class WAVE {

  /*
  Variables
   */

  ENEMY[] enemies;
  ArrayList theWave; /*The arraylist with all enemies*/
  WAYPOINTS theWayPoints; /*Global waypoints*/
  int enemyDistance = 50; /*Distance between two enemys*/
  int offsetDistance = 500; /*Offset before starting wave, fixing a weird bug with nullpointerexcp.*/
  int wholeDistance;
  boolean waveStarting = false;
  THEMAP defenseMap;

  /*
  Constructor
   */

  WAVE(WAYPOINTS itheWayPoints, int ienemyDistance, XML[] xmlEnemies, GUI itheGui, THEMAP idefenseMap) {
    defenseMap = idefenseMap;
    enemyDistance = ienemyDistance;
    theWayPoints = itheWayPoints;
    theWave = new ArrayList();
    wholeDistance = millis();    
    enemies = new ENEMY[xmlEnemies.length];

    /*Set enemies from XML*/
    for (int i=0;i<xmlEnemies.length;i++) {     
      for (int j=0;j<xmlEnemies[i].getInt("count");j++) {
        ENEMY temp = new ENEMY(xmlEnemies[i].getString("charset"), xmlEnemies[i].getString("icon"), xmlEnemies[i].getInt("tilesize"), xmlEnemies[i].getInt("maxhealth"), xmlEnemies[i].getInt("movespeed"), xmlEnemies[i].getInt("money"), xmlEnemies[i].getInt("damage"), xmlEnemies[i].getInt("animationspeed"), itheGui, defenseMap);
        if (j == 0) { 
          enemies[i] = temp;
        }
        theWave.add(temp);
      }
    }
  }

  /*
  Default constructor
   */

  WAVE() {
  }


  /*
  Start
   */
  void startWave() {
    wholeDistance = millis();
    waveStarting = true;
  }

  /*
  Distance between two Enemies
   */
  void calcEnemyDistance() {
    if (waveStarting == true) {
      int again = 0;
      for (int i = 0; i < theWave.size(); i++) {
        if ((millis()-wholeDistance) > (i*enemyDistance)+offsetDistance) {
          ENEMY temp = (ENEMY) theWave.get(i);
          if (temp.wayPointsSet == false) {
            temp.setWaypoints(theWayPoints.getStart(), theWayPoints.getEnd(), theWayPoints.getWP());
            again = i+1;
          }
        } 
        else { 
          break;
        }
      }
      if (again == theWave.size()) {
        waveStarting = false;
      }
    }
  }

  /*
  Display enemy Gui
   */
  void displayGui() {
    for (int i = 0; i < theWave.size(); i++) {
      if ((millis()-wholeDistance) > ((i*enemyDistance) + offsetDistance)) {
        ENEMY temp = (ENEMY) theWave.get(i);
        temp.displayGui();
      }
    }
  }

  /*
  Calculate enemies for splash
   */
  void waveSplash(ENEMY ienemy, int damage, int splashRadius, float splashFactor) {   
    for (int i=0; i<theWave.size(); i++) {
      ENEMY temp = (ENEMY) theWave.get(i);
      if ( dist(ienemy.position[0], ienemy.position[1], temp.position[0], temp.position[1]) < splashRadius && temp != ienemy && temp.enemyAlive == true) {
        temp.hitByTower((int) (damage*splashFactor), 0);
      }
    }
  }

  /*
  Return first enemy in tower radius
   */
  int waveCheckEnemy(int towerX, int towerY, int towerRadius, float freeze) {
    Collections.sort(theWave, new enemyComparator());
    ENEMY temp;
    int[] tempPos;
    int output = -1;

    for (int i = 0; i < theWave.size(); i++) {
      temp = (ENEMY) theWave.get(i);
      tempPos = temp.getPosition();
      if ( dist(tempPos[0], tempPos[1], towerX, towerY) <= towerRadius && temp.alive() == true && temp.position[0] > 0) {
        if (freeze == 0 || temp.frozen == false || (temp.freezeCount < (millis()-temp.freezeTime+300))) {
          output = i;
          break;
        }
      }
    }

    /*Check again if nothing was found, without the check if enemy is frozen*/
    if (output == -1) {
      for (int i = 0; i < theWave.size(); i++) {
        temp = (ENEMY) theWave.get(i);
        tempPos = temp.getPosition();
        if ( dist(tempPos[0], tempPos[1], towerX, towerY) <= towerRadius && temp.alive() == true && temp.position[0] > 0) {
          output = i;
          break;
        }
      }
    }

    return output;
  }

  /*
  Get next enemies
   */
  void waveNextEnemies(int x, int y) {
    for (int i = 0; i < enemies.length; i++) {
      if (enemies[i].enemyIcon != null) {      
        image(enemies[i].enemyIcon, x+(i*32), y);
      }
    }
  }

  /*
  Get enemy by id
   */
  ENEMY waveGetEnemy(int id) {
    return (ENEMY) theWave.get(id);
  }

  /*
  Check if wave is complete
   */
  boolean waveIsComplete() {
    boolean returnVar = true;
    for (int i = 0; i < theWave.size(); i++) {
      ENEMY temp = (ENEMY) theWave.get(i);
      if (temp.enemyAlive == true || temp.enemyDied == false) { 
        returnVar = false; 
        break;
      } 
      else { 
        temp = null;
      }
    }
    return returnVar;
  }
}

