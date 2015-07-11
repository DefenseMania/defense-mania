/*******************************************************
 
 Base class for an enemy unit
 
 *******************************************************/

class ENEMY {

  /*
  Variables  
   */

  /*Graphics & movement variables*/

  float moveComplete = 0;
  int enemyTileSize;
  int animationCount = 0;
  float animationSpeed = 10;
  int moveSpeed = 80;
  int[] moveVector = { 
    0, 0
  };
  int moveCount = 0;
  int moveDirection = 2;
  int moveState = 1;
  int moveStateDirection = 1;
  float[] position = { 
    -16, -16
  };
  PImage charSet;
  PImage enemyIcon;
  THEMAP defenseMap;
  int healthBarOffset = -1;

  /*Waypoint variables*/

  int[] startPoint;
  int[] endPoint;
  int[][] wayPoints;
  boolean wayPointsSet = false;
  int wpPosition;
  boolean reachingEndpoint;

  /*Game variables*/

  int maxHealth;
  int health;
  boolean enemyAlive = true;
  GUI theGui;
  int money = 1;
  int damage;
  int fireCount = 0;
  int fireRate = 1000;
  int fireRadius = 50;
  int freezeTime = 0;
  int freezeCount = 0;
  float freezeFactor = 0;
  float freezeFactorTemp = 1;
  boolean frozen = false;
  String charSetFile;
  boolean enemyDied = false;
  int dieCount = 0;
  int dieStep = 0;
  int dieTint = 255;
  boolean gotHit = false;
  int hitCount = 0;
  int hitStep = 0;
  String hitCharset;
  int hitXValue = 0;
  ArrayList towerHits = new ArrayList();

  /*
  Constructor
   */
  ENEMY(String icharSetFile, String ienemyIcon, int ienemyTileSize, int imaxHealth, int imoveSpeed, int imoney, int idamage, int ianimationSpeed, GUI itheGui, THEMAP idefenseMap) {
    charSetFile = icharSetFile;
    defenseMap = idefenseMap;
    defenseMap.theCharSets.addCharSet(icharSetFile, ienemyTileSize);
    charSet = defenseMap.theCharSets.getCharSet(icharSetFile);
    defenseMap.theCharSets.addCharSet(ienemyIcon, -1);
    enemyIcon = defenseMap.theCharSets.getCharSet(ienemyIcon);
    health = imaxHealth*defenseMap.difficulty;
    maxHealth = imaxHealth*defenseMap.difficulty;
    enemyTileSize = ienemyTileSize;
    theGui = itheGui;
    moveSpeed = imoveSpeed;
    money = imoney;
    damage = idamage*defenseMap.difficulty;
    animationSpeed = ianimationSpeed;
    moveCount = millis();
  } 


  /*
  Display
   */
  void display() {

    /*The die animation*/
    if (enemyDied == false && enemyAlive == false) {
      if (dieStep < 2) {
        if (millis()-dieCount > 100) {
          dieCount = millis();
          dieStep++;
        }
      } 
      else {
        /*Fade the enemy out*/       
        dieTint-=15;
        if (dieTint <= 15) {
          enemyDied = true;
        }
        tint(255, dieTint);
      }      
      image(defenseMap.theCharSets.getCharSetPart(charSetFile, dieStep, 4+moveDirection), position[0]-(enemyTileSize/2), position[1]-(enemyTileSize/2)-((enemyTileSize/2)-(defenseMap.tileSize/2))-(defenseMap.tileSize/4));
      noTint();
    }

    /*Only draw the character if we have to draw it*/
    if (wayPointsSet == true && enemyAlive == true) {

      /*Frozen by tower*/
      freezeFactorTemp = 1;
      if (freezeCount > millis()-freezeTime) {
        freezeFactorTemp = freezeFactor;
        if (globalPlatform != 2) {
          tint(0, 153, 204);
        }
      } 
      else {
        frozen = false;
      }

      /*Damage towers*/
      if (damage > 0) {
        if (millis()-fireCount >= (fireRate/(globalSpeed*freezeFactorTemp))) {
          defenseMap.theTowers.checkTowers((int) position[0], (int) position[1], fireRadius, damage);
          fireCount = millis();
        }
      }

      /*Animate the moving character*/
      if (millis()-animationCount >= (1000/(animationSpeed*globalSpeed*freezeFactorTemp))) {
        moveState += moveStateDirection;
        if (moveState == 3 || moveState == -1) {
          moveState = 1; 
          moveStateDirection *= -1;
        }
        animationCount=millis();
      }

      /*Move the character on waypoints */   
      checkWP();            
      float timeSinceLastMove = millis()-moveCount;
      float movementInPixels = (float) ((float) moveSpeed/1000)*timeSinceLastMove;        
      position[0] += (float) (moveVector[0]*globalSpeed*freezeFactorTemp*movementInPixels);
      position[1] += (float) (moveVector[1]*globalSpeed*freezeFactorTemp*movementInPixels);
      moveComplete += (float) abs(moveVector[0]*globalSpeed*freezeFactorTemp*movementInPixels) + (float) abs(moveVector[1]*globalSpeed*freezeFactorTemp*movementInPixels);
      moveCount = millis();

      defenseMap.theAnimations.animate(this);

      /*Draw the character image */     
      image(defenseMap.theCharSets.getCharSetPart(charSetFile, moveState, moveDirection), position[0]-(enemyTileSize/2), position[1]-(enemyTileSize/2)-((enemyTileSize/2)-(defenseMap.tileSize/2))-(defenseMap.tileSize/4));
      noTint();
    }

    /*If the hit-animation is on the enemy itself, display it here*/
    if (gotHit == true) {
      PImage hitImg = null;
      if ((millis()-hitCount) < 80) {
        hitImg = defenseMap.theCharSets.getCharSetPart(hitCharset, hitXValue, 1);
      } 
      else if ((millis()-hitCount) < 160) {
        hitImg = defenseMap.theCharSets.getCharSetPart(hitCharset, hitXValue+1, 1);
      } 
      else if ((millis()-hitCount) < 240) {
        hitImg = defenseMap.theCharSets.getCharSetPart(hitCharset, hitXValue+2, 1);
      } 
      else {
        gotHit = false;
      }
      imageMode(CENTER);
      if (hitImg != null) {
        image(hitImg, position[0], position[1]-((enemyTileSize/2)-(defenseMap.tileSize/2)));
      }  
      imageMode(CORNER);
    }
  }


  /*
  Display enemy Gui
   */
  void displayGui() {
    if (wayPointsSet == true && enemyAlive == true) {    
      /*Draw the healthbar*/
      if (health < maxHealth) {
        stroke(50);
        fill(204, 0, 51);
        rect(position[0]-(enemyTileSize/2)+(enemyTileSize*0.25), position[1]-(enemyTileSize/2)-(enemyTileSize*0.25)-((enemyTileSize/2)-(defenseMap.tileSize/2))+healthBarOffset, enemyTileSize*0.5, 3);
        fill(0, 204, 51);
        rect(position[0]-(enemyTileSize/2)+(enemyTileSize*0.25), position[1]-(enemyTileSize/2)-(enemyTileSize*0.25)-((enemyTileSize/2)-(defenseMap.tileSize/2))+healthBarOffset, enemyTileSize*0.5*((float) health / (float)maxHealth), 3);
      }
    }
  }


  /*
  Set Waypoints (not in the constructor because of a possible other pathfinding engine later) 
   */
  void setWaypoints(int[] istartPoint, int[] iendPoint, int[][] iwayPoints) {
    startPoint = istartPoint;
    endPoint = iendPoint;
    wayPoints = iwayPoints;
    spawnEnemy();
    calculateMoveVector();
    calcHealthbarOffset(); 
    wayPointsSet = true;
    moveCount = millis();
  }

  /*
  Spawn on start-position
   */
  void spawnEnemy() {
    reachingEndpoint = false;
    position[1] = startPoint[1];
    position[0] = startPoint[0]-enemyTileSize;
    wpPosition = -1;
    moveCount = millis();
  }

  /*
  Check if character reaches WP
   */
  void checkWP() {   
    int[] nextPoint;    
    if (wpPosition >= wayPoints.length) {
      nextPoint = new int[2];
      nextPoint[1] = endPoint[1];
      /*INTBUG*/
      nextPoint[0] = endPoint[0] + int(enemyTileSize);     
      reachingEndpoint = true;
    } 
    else {
      nextPoint = wayPoints[wpPosition];
    }

    if (moveVector[0] < 0) {    
      if (position[0] <= nextPoint[0]) {
        position[0] = nextPoint[0];
        if (reachingEndpoint == true) { 
          gotToEnd();
        }
        calculateMoveVector();
      }
    } 
    else if (moveVector[0] > 0) {
      if (position[0] >= nextPoint[0]) {
        position[0] = nextPoint[0];
        if (reachingEndpoint == true) { 
          gotToEnd();
        }
        calculateMoveVector();
      }
    } 
    else if (moveVector[1] < 0) {
      if (position[1] <= nextPoint[1]) {
        position[1] = nextPoint[1];
        if (reachingEndpoint == true) { 
          gotToEnd();
        }
        calculateMoveVector();
      }
    } 
    else if (moveVector[1] > 0) {
      if (position[1] >= nextPoint[1]) {
        position[1] = nextPoint[1];
        if (reachingEndpoint == true) { 
          gotToEnd();
        }
        calculateMoveVector();
      }
    }
  }

  /*
  Calculate the new movement vector
   */
  void calculateMoveVector() {
    wpPosition++;
    moveVector[0] = 0; 
    moveVector[1] = 0;
    int[] nextPoint;

    if (wpPosition >= wayPoints.length) {
      nextPoint = endPoint;
    } 
    else {
      nextPoint = wayPoints[wpPosition];
    }     

    if (nextPoint[0]-position[0] > 0+freezeFactorTemp) {      
      moveVector[0] = 1;
      moveDirection = 2;
    } 
    else if (nextPoint[0]-position[0] < 0-freezeFactorTemp) {      
      moveVector[0] = -1; 
      moveDirection = 1;
    }
    if (nextPoint[1]-position[1] > 0+freezeFactorTemp) {      
      moveVector[1] = 1;
      moveDirection = 0;
    } 
    else if (nextPoint[1]-position[1] < 0-freezeFactorTemp) {      
      moveVector[1] = -1;
      moveDirection = 3;
    }
  }


  /*
  Enemy reached the endpoint
   */
  void gotToEnd() {   
    defenseMap.theGui.enemyReachedEnd();
    enemyAlive = false;
  }

  /*
  Got hit by a tower
   */
  void hitByTower(int damage, float freeze) {   
    getDamageByTower(damage, freeze);
  }

  /*
  Got hit by a tower with increasing damage per shot
   */
  void hitByTower(int damage, float freeze, TOWER tower, float multiplier) {
    int hitDamage = damage;
    boolean foundTower = false;    
    for (int i = 0; i < towerHits.size(); i++) {
      towerHit temp = (towerHit) towerHits.get(i);
      if (temp.tower.equals(tower)) {
        foundTower = true;
        hitDamage = temp.getDamage();
        break;
      }
    }             
    if (foundTower == false) {
      towerHits.add( new towerHit(tower, damage, multiplier) );
    }      
    getDamageByTower(hitDamage, freeze);
  }

  /*
  Tower makes damage
   */
  void getDamageByTower(int damage, float freeze) {
    if (freeze > 0) {
      freezeCount = millis();
      freezeFactor = freeze;
      frozen = true;
      freezeTime = 2500;
    }
    health -= damage;
    if (health < 0) {
      moveComplete = 999999999;
      enemyAlive = false;
      dieCount = millis();
      defenseMap.theGui.enemyKilled(money);
    }
  }

  /*
  Get position
   */
  int[] getPosition() {
    return new int[] { 
      (int) position[0], (int) position[1]
    };
  }

  /*
  Get status
   */
  boolean alive() {
    return enemyAlive;
  }

  /*
  Hit Animation
   */
  void hitAnimation(String ihitCharset, int x) {
    gotHit = true;
    hitCount = millis();
    hitStep = 0; 
    hitXValue = x;
    hitCharset = ihitCharset;
  }

  /*
  Calc the position in a specific time
   */
  float[] calcEnemyPosInFuture(int time) {
    float returnPosition[] = new float[2];
    float movementInPixels = (float) ((float) moveSpeed/1000)*time;        
    returnPosition[0] = (float) position[0] + (moveVector[0]*globalSpeed*freezeFactorTemp*movementInPixels);
    returnPosition[1] = (float) position[1] + (moveVector[1]*globalSpeed*freezeFactorTemp*movementInPixels);
    return returnPosition;
  }

  /*
  Healthbar Offset
   */
  void calcHealthbarOffset() {
    /*INTBUG*/
    PImage tempCharSet = defenseMap.theCharSets.getCharSetPart(charSetFile, 1, 0);
    tempCharSet.loadPixels();    
    for (int y = 0; y < tempCharSet.height; y++) {
      if (healthBarOffset == -1) {
        for (int x = 0; x < tempCharSet.width; x++) {        
          int loc = x + y*tempCharSet.width;        
          if (alpha(tempCharSet.pixels[loc]) != 0) {
            healthBarOffset = (y-1);         
            break;
          }
        }
      } 
      else { 
        break;
      }
    }
  }
}


/*******************************************************
 
 Object for saving TOWERS that make increased damage per shot
 
 *******************************************************/

class towerHit {

  /*Some Vars*/
  TOWER tower;
  int count = 1;
  int damage;
  float multiplier;

  /*Constructor*/
  towerHit(TOWER itower, int idamage, float imultiplier) {
    tower = itower;
    damage = idamage;
    multiplier = imultiplier;
  }

  /*Get current damage that is multiplied with each hit*/
  int getDamage() {          
    int returnVar = damage;
    for (int i = 0; i < count; i++) {
      returnVar*=multiplier;
    }
    count++; 
    return returnVar;
  }
}

