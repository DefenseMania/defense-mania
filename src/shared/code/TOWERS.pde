/*******************************************************
 
 Base class for managing the towers
 
 *******************************************************/

class TOWERS {

  /*
  Variables
   */

  XML xmlData; /*XML Object*/
  ArrayList towers; /*All the build towers*/
  TOWERTYPE[] towerTypes; /*All the available tower types*/
  THEMAP defenseMap; /*Reference to the map*/

  /*
  Constructor
   */
  TOWERS(String mapFile, THEMAP idefenseMap) {

    towers = new ArrayList();
    defenseMap = idefenseMap; 

    /*Load tower data from XML*/
    xmlData = loadXML(mapFile + "/towers.xml");
    XML[] xmlTowers = xmlData.getChildren("towers/tower");
    towerTypes = new TOWERTYPE[xmlTowers.length];

    /*And set the tower types*/
    for (int i=0; i<xmlTowers.length; i++) {
      boolean explosionAtEnemy = false;
      boolean hasShootingAnimation = false;
      if (xmlTowers[i].getInt("explosionatenemy") == 1) {
        explosionAtEnemy = true;
      }
      if (xmlTowers[i].getInt("hasshootinganimation") == 1) {
        hasShootingAnimation = true;
      }
      /*INTBUG*/
      int updates = int(xmlTowers[i].getInt("updates"));
      if (updates > 0) {
        int[] ucosts = new int[updates];
        int[] udamage = new int[updates];
        int[] ufirerate = new int[updates];
        int[] ufireradius = new int[updates];
        for (int j=0;j<updates;j++) {
          ucosts[j] = xmlTowers[i].getInt("u"+(j+1)+"-costs");
          udamage[j] = xmlTowers[i].getInt("u"+(j+1)+"-damage");
          ufirerate[j] = xmlTowers[i].getInt("u"+(j+1)+"-firerate");
          ufireradius[j] = xmlTowers[i].getInt("u"+(j+1)+"-fireradius");
        }       
        towerTypes[i] = new TOWERTYPE(xmlTowers[i].getString("name"), xmlTowers[i].getString("charset"), explosionAtEnemy, hasShootingAnimation, xmlTowers[i].getString("towericon"), xmlTowers[i].getInt("towericonsize"), xmlTowers[i].getInt("tilesize"), xmlTowers[i].getInt("damage"), xmlTowers[i].getInt("firerate"), xmlTowers[i].getInt("fireradius"), xmlTowers[i].getInt("splash"), xmlTowers[i].getInt("splashradius"), xmlTowers[i].getFloat("splashfactor"), xmlTowers[i].getFloat("freeze"), xmlTowers[i].getInt("costs"), xmlTowers[i].getInt("maxhealth"), xmlTowers[i].getContent(), xmlTowers[i].getFloat("damageincrease"), xmlTowers[i].getInt("updates"), ucosts, udamage, ufirerate, ufireradius);
      } 
      else {
        towerTypes[i] = new TOWERTYPE(xmlTowers[i].getString("name"), xmlTowers[i].getString("charset"), explosionAtEnemy, hasShootingAnimation, xmlTowers[i].getString("towericon"), xmlTowers[i].getInt("towericonsize"), xmlTowers[i].getInt("tilesize"), xmlTowers[i].getInt("damage"), xmlTowers[i].getInt("firerate"), xmlTowers[i].getInt("fireradius"), xmlTowers[i].getInt("splash"), xmlTowers[i].getInt("splashradius"), xmlTowers[i].getFloat("splashfactor"), xmlTowers[i].getFloat("freeze"), xmlTowers[i].getInt("costs"), xmlTowers[i].getInt("maxhealth"), xmlTowers[i].getContent(), xmlTowers[i].getFloat("damageincrease"), xmlTowers[i].getInt("updates"));
      }
    }
  }

  /*
  Default constructor
   */
  TOWERS() {
  }

  /*
  Is there a tower?
   */
  int isTower(int x, int y) {
    int returnVar = -1;
    int[] temp_pos = pixelToTiles(x, y, defenseMap.tileSize);

    for (int i=0; i<towers.size(); i++) {
      TOWER temp = (TOWER) towers.get(i);
      if (temp.position[0] == temp_pos[0] && temp.position[1] == temp_pos[1] && temp.towerDestroyed == false) {
        returnVar = i; 
        break;
      }
    }
    return returnVar;
  }

  /*
  Get tower by id
   */
  TOWER getTower(int id) {
    return (TOWER) towers.get(id);
  }

  /*
  Remove tower
   */
  void removeTower(TOWER itower) {
    for (int i=0; i<towers.size(); i++) {
      TOWER temp = (TOWER) towers.get(i);
      if (itower.equals(temp)) {
        temp = null;
        towers.remove(i);
        break;
      }
    }
  }

  /*
  Add tower
   */
  void addTower(int id, int x, int y) {
    if (towerTypes[id].costs <= defenseMap.theGui.money) {
      if (defenseMap.gameStarted == false) {
        defenseMap.theActions.startGame();
      }
      defenseMap.theGui.money -= towerTypes[id].costs;
      int[] temp = new int[2];
      temp[0] = x;
      temp[1] = y;
      if (towerTypes[id].updates > 0) {
        towers.add(new TOWER(towerTypes[id].charSet, towerTypes[id].explosionAtEnemy, towerTypes[id].hasShootingAnimation, towerTypes[id].tileSize, temp[0], temp[1], towerTypes[id].name, towerTypes[id].damage, towerTypes[id].fireRate, towerTypes[id].fireRadius, towerTypes[id].maxHealth, towerTypes[id].splashDamage, towerTypes[id].splashRadius, towerTypes[id].splashFactor, towerTypes[id].freeze, towerTypes[id].costs, towerTypes[id].description, defenseMap, towerTypes[id].damageIncrease, towerTypes[id].updates, towerTypes[id].ucosts, towerTypes[id].udamage, towerTypes[id].ufirerate, towerTypes[id].ufireradius));
      } 
      else {
        towers.add(new TOWER(towerTypes[id].charSet, towerTypes[id].explosionAtEnemy, towerTypes[id].hasShootingAnimation, towerTypes[id].tileSize, temp[0], temp[1], towerTypes[id].name, towerTypes[id].damage, towerTypes[id].fireRate, towerTypes[id].fireRadius, towerTypes[id].maxHealth, towerTypes[id].splashDamage, towerTypes[id].splashRadius, towerTypes[id].splashFactor, towerTypes[id].freeze, towerTypes[id].costs, towerTypes[id].description, defenseMap, towerTypes[id].damageIncrease, towerTypes[id].updates));
      }
    }
  }


  /*
  Display GUI
   */
  void displayGui() {
    for (int i=0; i<towers.size(); i++) {
      TOWER temp = (TOWER) towers.get(i);
      temp.displayGui();
    }
  }

  /*
  Display arrows & Hit Animations
   */
  void displayArrow() {
    for (int i=0; i<towers.size(); i++) {
      TOWER temp = (TOWER) towers.get(i);
      temp.displayArrow();
      temp.hitAnimation();
    }
  }


  /*
  Check towers
   */
  void checkTowers(int x, int y, int radius, int damage) {
    for (int i=0; i<towers.size(); i++) {
      TOWER temp = (TOWER) towers.get(i);
      if ( dist((temp.position[0]+0.5)*defenseMap.getTileSize(), (temp.position[1]+0.5)*defenseMap.getTileSize(), x, y) <= radius ) {
        temp.enemyDamage(damage);
      }
    }
  }

  /*
  Sell Tower
   */
  void sellTower(TOWER itower) {
    defenseMap.theGui.money += (int) (itower.costs*0.8);
    for (int i=0; i<towers.size(); i++) {
      TOWER temp = (TOWER) towers.get(i);
      if ( temp.equals(itower) == true ) {
        temp = null;
        towers.remove(i);
        break;
      }
    }
  }
}

