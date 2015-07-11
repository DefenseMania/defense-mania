/*******************************************************
 
 Comparator classes for comparing enemies and towers for drawing or shooting at them in the right order
 
 *******************************************************/


/*
 Compare two objects with each other by their y-position
 */
class displayComparator implements Comparator<Object> {
  public int compare(Object o1, Object o2) {   

    float position1 = 0;
    float position2 = 0;

    if (o1 instanceof TOWER) {
      TOWER temp = (TOWER) o1;
      position1 = (temp.position[1]+0.5f) * defenseMap.tileSize;
    } 
    else {
      ENEMY temp = (ENEMY) o1;
      if (temp.enemyDied == false && temp.enemyAlive == false && (temp.moveDirection == 1 || temp.moveDirection == 2)) {
        position1 = -50;
      } 
      else {
        position1 = temp.position[1];
      }
    }

    if (o2 instanceof TOWER) {
      TOWER temp = (TOWER) o2;
      position2 = (temp.position[1]+0.5f) * defenseMap.tileSize;
    } 
    else {
      ENEMY temp = (ENEMY) o2;
      if (temp.enemyDied == false && temp.enemyAlive == false && (temp.moveDirection == 1 || temp.moveDirection == 2)) {
        position2 = -50;
      } 
      else {        
        position2 = temp.position[1];
      }
    }

    return (int) (position2-position1);
  }
}

/*
Compare two enemies to calculate the right shooting order
 */

class enemyComparator implements Comparator<ENEMY> {
  public int compare(ENEMY enemy1, ENEMY enemy2) {
    int returnVar = 0;
    returnVar = (int) (enemy2.moveComplete - enemy1.moveComplete);
    return returnVar;
  }
}

