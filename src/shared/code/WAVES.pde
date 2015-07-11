/*******************************************************
 
 Base class for managing all the waves
 
 *******************************************************/

class WAVES {

  /*
 Variables
   */
  XML xmlData; /*XML Object*/
  WAVE[] theWaves; /*All the waves*/
  int currentWave = 0; /*The current wave id*/
  THEMAP defenseMap;
  boolean started = false;

  /*
 Constructor
   */
  WAVES(String mapFile, WAYPOINTS itheWaypoints, GUI itheGui, THEMAP idefenseMap) {

    defenseMap = idefenseMap;

    /*Load data from XML file*/
    xmlData = loadXML(mapFile + "/waves.xml");
    XML[] xmlWaves = xmlData.getChildren("waves/wave");

    /*Set Waves*/
    theWaves = new WAVE[xmlWaves.length];
    for (int i = 0; i<xmlWaves.length; i++) {
      theWaves[i] = new WAVE(itheWaypoints, xmlWaves[i].getInt("enemydistance"), xmlWaves[i].getChildren("enemy"), itheGui, defenseMap);
    }
  }

  WAVES() {
  }

  /*
 Start next wave
   */
  void nextWave() {
    started = true;  
    theWaves[currentWave].startWave();
  }

  /*
 Display Gui
   */
  void displayGui() {
    if (started == true) {
      theWaves[currentWave].displayGui();
    }
  }

  /*
 Check if wave is complete
   */
  void waveComplete() { 
    if (theWaves[currentWave].waveIsComplete() == true && defenseMap.defeated == false) {   
      if (currentWave+1 >= theWaves.length) {     
        defenseMap.theActions.wonGame();
      } 
      else {
        theWaves[currentWave] = null;
        currentWave++;
        defenseMap.theActions.continueNextWave();
      }
    }
  }

  /*
Display next Enemies
   */

  void nextEnemies(int x, int y) {
    if (currentWave+1 < theWaves.length) {
      theWaves[currentWave+1].waveNextEnemies(x, y);
    }
  }

  /*
 Check enemy
   */
  int checkEnemy(int towerX, int towerY, int towerRadius, float freeze) {
    return theWaves[currentWave].waveCheckEnemy(towerX, towerY, towerRadius, freeze);
  }

  /*
 Get enemy
   */
  ENEMY getEnemy(int id) {
    return theWaves[currentWave].waveGetEnemy(id);
  }

  /*
 Splash damage
   */
  void splashDamage(ENEMY ienemy, int damage, int splashRadius, float splashFactor) {
    theWaves[currentWave].waveSplash(ienemy, damage, splashRadius, splashFactor);
  }
}

