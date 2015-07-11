/*******************************************************
 
 Base class for displaying enemies & towers in the right order
 
 *******************************************************/

class DISPLAY {

  /*
   Variables
   */
  ArrayList displayItems;
  THEMAP defenseMap;

  /*
  Constructor
   */
  DISPLAY(THEMAP idefenseMap) {

    defenseMap = idefenseMap;
    displayItems = new ArrayList();
  }

  /*
  Display
   */
  void display() {


    /*Add enemies & towers to display queue*/
    displayItems.addAll(defenseMap.theTowers.towers);
    if (defenseMap.enemyWaves.started == true) {
      displayItems.addAll(defenseMap.enemyWaves.theWaves[defenseMap.enemyWaves.currentWave].theWave);   

      /*Some methods for the currentWave*/
      defenseMap.enemyWaves.waveComplete();
      defenseMap.enemyWaves.theWaves[defenseMap.enemyWaves.currentWave].calcEnemyDistance();
    }

    /*Sort the queue*/
    Collections.sort(displayItems, new displayComparator());

    /*Display it*/
    for (int i = displayItems.size()-1; i >= 0; i--) {
      Object temp = (Object) displayItems.get(i);
      if (temp instanceof TOWER) {
        TOWER temp2 = (TOWER) temp;
        temp2.display();
      } 
      else {
        ENEMY temp2 = (ENEMY) temp;
        temp2.display();
      }
    }

    /*Clear the queue*/
    displayItems.clear();
  }
}

