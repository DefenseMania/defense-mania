/*******************************************************
 
 Base class for an tower unit
 
 *******************************************************/

class TOWER {

  /*
  Variables  
   */

  /*Graphics & general variables*/

  PImage charSet; /*The tower charset-image*/
  int[] position = { 
    -1, -1
  }; /*Default position outside frame*/
  int towerTileSize = 32; /*Default tilesize*/
  THEMAP defenseMap; /*Link to the Map*/
  int drawingOffset = 5; /*Fixing a weird bug, that causes a nullpointerexception*/
  int drawingCount = 0; /*Counting some frames*/
  boolean drawTowerRadius = false; /*Should we draw the shooting radius?*/
  int towerDirection = 3; /*Direction Tower is looking*/
  boolean explosionAtEnemy = true; /*Explosion at Enemy or at Arrow?*/
  String charSetFile;

  /*Game variables*/

  String name; /*Name of the Tower*/
  boolean enemyInReach = false; /*Is enemy in reach?*/
  int damage = 15; /*Tower damage*/
  int fireRate = 500; /*Firerate = time in ms between two tower shots*/
  int fireRadius; /*Fireradius in px*/
  int fireCount = 0; /*Count frames*/
  int health; /*Health*/
  int maxHealth; /*Maximal health*/
  boolean splash = false; /*Does the tower splash damage?*/
  int splashRadius; /*Radius of the Splash damage*/
  float splashFactor; /*How much damage is dealt in splash*/
  int costs; /*Costs to build the tower*/
  String description; /*Description*/
  float freeze;
  int updates;
  int[] udamage;
  int[] ucosts;
  int[] ufirerate;
  int[] ufireradius;
  int currentUpdate = 0;
  int animationCount = 0;
  int animationState = 0;
  int animationStateDirection = 1;
  int animationSpeed = 5;
  float shootAngle;
  boolean shooting = false;
  PImage arrow;
  int shootingCount = 0;
  int shootDirection = 0;
  float arrowPosition[] = new float[2];
  float enemyPosition[] = new float[2];
  ENEMY shootAtEnemy;
  int shootingAniState = 0;
  int enemyLastHit = 0;
  int hitAniCount = 0;
  float[] hitAniPos = new float[2];
  PImage hitAni;
  PImage hitAniImg;
  boolean hitAniBool = false;
  boolean towerDestroyed = false;
  int towerDestroyCount = 0;
  int towerDestroyOpacity = 255;
  boolean hasShootingAnimation;
  float damageIncrease;


  /*
  Constructors  
   */
  public TOWER(String icharSetFile, boolean iexplosionAtEnemy, boolean ihasShootingAnimation, int itileSize, int x, int y, String iname, int idamage, int ifireRate, int ifireRadius, int imaxHealth, boolean isplash, int isplashRadius, float isplashFactor, float ifreeze, int icosts, String idescription, THEMAP idefenseMap, float idamageIncrease, int iupdates) {
    towerTileSize = itileSize;
    position[0] = x;
    position[1] = y;
    defenseMap = idefenseMap;
    charSetFile = icharSetFile;
    defenseMap.theCharSets.addCharSet(charSetFile, itileSize);    
    charSet = defenseMap.theCharSets.getCharSet(charSetFile);
    maxHealth = imaxHealth;
    health = imaxHealth;
    name = iname;
    splash = isplash;
    fireRate = ifireRate;
    fireRadius = ifireRadius;
    damage = idamage;
    costs = icosts;
    splashRadius = isplashRadius;
    splashFactor = isplashFactor;
    description = idescription;
    freeze = ifreeze;
    updates = iupdates;
    explosionAtEnemy = iexplosionAtEnemy;
    hasShootingAnimation = ihasShootingAnimation;
    damageIncrease = idamageIncrease;
  }

  public TOWER(String icharSetFile, boolean iexplosionAtEnemy, boolean ihasShootingAnimation, int itileSize, int x, int y, String iname, int idamage, int ifireRate, int ifireRadius, int imaxHealth, boolean isplash, int isplashRadius, float isplashFactor, float ifreeze, int icosts, String idescription, THEMAP idefenseMap, 
  float idamageIncrease, int iupdates, int[] iucosts, int[] iudamage, int[] iufirerate, int[] iufireradius) {
    towerTileSize = itileSize;
    position[0] = x;
    position[1] = y;
    defenseMap = idefenseMap;
    charSetFile = icharSetFile;
    defenseMap.theCharSets.addCharSet(charSetFile, itileSize);    
    charSet = defenseMap.theCharSets.getCharSet(charSetFile);
    maxHealth = imaxHealth;
    health = imaxHealth;
    name = iname;
    splash = isplash;
    fireRate = ifireRate;
    fireRadius = ifireRadius;
    damage = idamage;
    costs = icosts;
    splashRadius = isplashRadius;
    splashFactor = isplashFactor;
    description = idescription;
    freeze = ifreeze;
    updates = iupdates;
    ucosts = iucosts;
    udamage = iudamage;
    ufirerate = iufirerate;
    ufireradius = iufireradius;
    explosionAtEnemy = iexplosionAtEnemy;
    hasShootingAnimation = ihasShootingAnimation;
    damageIncrease = idamageIncrease;
  }

  /*
  Display  
   */
  void display() { 

    if (towerDestroyed == false) {

      if (drawingCount >= drawingOffset) {

        float shootAngleTemp = shootAngle + (shootDirection*PI);    

        /*Set tileset by shooting angle*/
        if (millis()-enemyLastHit > 3000) {
          towerDirection = 2;
        } 
        else if (shootAngleTemp > PI/8 && shootAngleTemp <= (PI*3/8)) {
          towerDirection = 1; /*Left45*/
        } 
        else if (shootAngleTemp > (PI*3/8) && shootAngleTemp <= (PI*5/8)) {
          towerDirection = 0; /*Top*/
        } 
        else if (shootAngleTemp > (PI*5/8) && shootAngleTemp <= (PI*7/8)) {
          towerDirection = 5; /*Right45*/
        } 
        else if (shootAngleTemp > (PI*7/8) && shootAngleTemp <= (PI+(PI/8))) {
          towerDirection = 6; /*Right90*/
        } 
        else if ((shootAngleTemp > (PI+(PI/8)) && shootAngleTemp <= (PI+(PI*3/8))) || (shootAngleTemp < -(PI*5/8) && shootAngleTemp >= -(PI*7/8))) {
          towerDirection = 7; /*Right135*/
        } 
        else if ((shootAngleTemp > (PI+(PI*3/8)) && shootAngleTemp <= (PI+(PI*5/8))) || (shootAngleTemp < -(PI*3/8) && shootAngleTemp >= -(PI*5/8))) {
          towerDirection = 4; /*Bottom*/
        } 
        else if ((shootAngleTemp > (PI+(PI*5/8)) && shootAngleTemp <= (PI+(PI*7/8))) || (shootAngleTemp < -(PI/8) && shootAngleTemp >= -(PI*3/8))) {
          towerDirection = 3; /*Left135*/
        } 
        else {
          towerDirection = 2; /*Left90*/
        }

        defenseMap.theAnimations.animate(this);

        if (shooting == true && shootingAniState < 3 && hasShootingAnimation == true) {

          /*The Shooting Animation*/      
          imageMode(CENTER);          
          image(defenseMap.theCharSets.getCharSetPart(charSetFile, (currentUpdate*9)+(shootingAniState)+(3), towerDirection), (float) (position[0]+0.5f)*defenseMap.getTileSize(), ((float) (position[1]+0.5f)*defenseMap.getTileSize())-((towerTileSize-defenseMap.getTileSize())/2));         
          imageMode(CORNER);
          if (millis()-shootingCount > fireRate*0.08f*(shootingAniState+1)) {        
            if (shootingAniState < 3) { 
              shootingAniState++;
            }
          }
        } 
        else {

          /*Animate the Tower*/
          if (millis()-animationCount >= (1000/(animationSpeed*globalSpeed))) {
            animationState += animationStateDirection;
            if (animationState == 3 || animationState == -1) {
              animationState = 1; 
              animationStateDirection *= -1;
            }
            animationCount=millis();
          }

          /*Draw tower image*/
          imageMode(CENTER);
          image(defenseMap.theCharSets.getCharSetPart(charSetFile, (currentUpdate*9)+(animationState), towerDirection), (float) (position[0]+0.5f)*defenseMap.getTileSize(), ((float) (position[1]+0.5f)*defenseMap.getTileSize())-((towerTileSize-defenseMap.getTileSize())/2));
          imageMode(CORNER);
        }

        defenseMap.theAnimations.animateEnd(this);

        /*Check & Shoot*/
        if (millis()-fireCount >= (fireRate/globalSpeed)) {
          checkEnemy();
          fireCount = millis();
        }
      } 
      else { 
        drawingCount++;
      }
    } 
    else {

      /*Die Animation*/
      imageMode(CENTER);
      int destroyState = 8;
      if (millis()-towerDestroyCount < 100) {
        destroyState = 6;
      } 
      else if (millis()-towerDestroyCount < 200) {
        destroyState = 7;
      } 
      else if (millis()-towerDestroyCount < 300) {
      } 
      else if (millis()-towerDestroyCount < 400) {
      } 
      else if (millis()-towerDestroyCount < 7000) {
        tint(255, towerDestroyOpacity);
        if (towerDestroyOpacity > 4) { 
          towerDestroyOpacity-=10;
        } 
        else { 
          towerDestroyOpacity=0;
        }
      } 
      else {
        tint(255, 0);
        defenseMap.theTowers.removeTower(this);
      }
      image(defenseMap.theCharSets.getCharSetPart(charSetFile, (currentUpdate*9)+(destroyState), 0), (float) (position[0]+0.5f)*defenseMap.getTileSize(), ((float) (position[1]+0.5f)*defenseMap.getTileSize())-((towerTileSize-defenseMap.getTileSize())/2));
      noTint();
      imageMode(CORNER);
    }
  }

  /*
   Display Tower GUI
   */
  void displayGui() {

    /*Display the health-bar*/
    if (health < maxHealth && towerDestroyed == false) {
      stroke(50);
      fill(204, 0, 51);
      rect((position[0]*defenseMap.getTileSize())+(towerTileSize*0.1), (position[1]*defenseMap.getTileSize())-(towerTileSize*0.25), defenseMap.getTileSize()*0.7, 3);
      fill(0, 204, 51);
      rect((position[0]*defenseMap.getTileSize())+(towerTileSize*0.1), (position[1]*defenseMap.getTileSize())-(towerTileSize*0.25), defenseMap.getTileSize()*0.7*((float) health / (float)maxHealth), 3);
    }


    /*Display the fire radius*/
    if (drawTowerRadius == true && towerDestroyed == false) {
      fill(204, 255, 153, 100);
      stroke(204, 255, 153, 200);
      ellipseMode(CENTER);
      ellipse((position[0]+0.5)*defenseMap.getTileSize(), (position[1]+0.5)*defenseMap.getTileSize(), fireRadius, fireRadius);
    }
  }

  /*
   Display Tower Arrow
   */
  void displayArrow() {
    if (shooting == true) {
      if ((millis()-shootingCount) < (fireRate*0.5f)) {      
        float c = dist((position[0]+0.5)*defenseMap.getTileSize(), ((position[1]+0.5)*defenseMap.getTileSize())-((towerTileSize-defenseMap.tileSize)/2), enemyPosition[0], enemyPosition[1]);
        float proz = (millis()-shootingCount)/(fireRate*0.7f);
        arrowPosition[0] = cos(shootAngle+(shootDirection*PI))*(c-(proz*c));
        arrowPosition[1] = sin(shootAngle+(shootDirection*PI))*(c-(proz*c));            

        pushMatrix();
        imageMode(CENTER);
        translate(enemyPosition[0], enemyPosition[1]);
        translate(arrowPosition[0], arrowPosition[1]);
        rotate(shootAngle+(shootDirection*PI));
        if ((proz < 0.10f || proz > 0.95f) && globalPlatform != 2) { 
          tint(255, 80);
        }       
        arrow = defenseMap.theCharSets.getCharSetPart(charSetFile, (currentUpdate*9)+(6)+(animationState), 2);
        if (proz > 0.05f) {
          image(arrow, 0, 0);
        }        
        imageMode(CORNER);        
        noTint(); 
        popMatrix();
      } 
      else {
        if (damageIncrease > 0) {
          shootAtEnemy.hitByTower(damage, freeze, this, damageIncrease);
          if (splash == true) { 
            defenseMap.enemyWaves.splashDamage(shootAtEnemy, damage, splashRadius, splashFactor);
          }
        } 
        else {
          shootAtEnemy.hitByTower(damage, freeze);
          if (splash == true) { 
            defenseMap.enemyWaves.splashDamage(shootAtEnemy, damage, splashRadius, splashFactor);
          }
        }

        /*INTBUG*/
        if (explosionAtEnemy == true) {
          shootAtEnemy.hitAnimation(charSetFile, 6+int(currentUpdate*9));
        } 
        else {
          hitAniCount = millis();
          hitAniPos[0] = int(enemyPosition[0]);
          hitAniPos[1] = int(enemyPosition[1]);
          hitAniBool = true;
        }
        shooting = false;
        shootingAniState = 0;
      }
    }
  }

  /*
  Hit Animation
   */
  void hitAnimation() {    
    if (hitAniBool == true) {
      if ((millis()-hitAniCount) < 80) {
        hitAniImg = defenseMap.theCharSets.getCharSetPart(charSetFile, int(6)+int(currentUpdate*9), 1);
      } 
      else if ((millis()-hitAniCount) < 160) {
        hitAniImg = defenseMap.theCharSets.getCharSetPart(charSetFile, int(7)+int(currentUpdate*9), 1);
      } 
      else if ((millis()-hitAniCount) < 240) {
        hitAniImg = defenseMap.theCharSets.getCharSetPart(charSetFile, int(8)+int(currentUpdate*9), 1);
      } 
      else {
        hitAniBool = false;
      }
      imageMode(CENTER);
      image(hitAniImg, hitAniPos[0], hitAniPos[1]);    
      imageMode(CORNER);
    }
  }

  /*
  Check, focus and shoot on/at an enemy  
   */
  void checkEnemy() {
    int id = defenseMap.enemyWaves.checkEnemy((int) ((position[0]+0.5)*defenseMap.getTileSize()), (int) ((position[1]+0.5)*defenseMap.getTileSize()), (fireRadius/2)+(towerTileSize/4), freeze );
    if (id != -1) {
      ENEMY temp = defenseMap.enemyWaves.getEnemy(id);
      shootAtEnemy = temp;
      float[] enemyPos = temp.calcEnemyPosInFuture((int) (fireRate*0.5f));
      shoot(enemyPos[0], enemyPos[1]-((temp.enemyTileSize/2)-(defenseMap.tileSize/2)));
    }
  }

  /*
  Calculate the shoot angle
   */
  void calculateShootAngle(float x, float y) {
    shootAngle = atan( ((((position[1]+0.5f)*defenseMap.getTileSize())-((towerTileSize-defenseMap.tileSize)/2))-y)/(((position[0]+0.5f)*defenseMap.getTileSize())-x) );
  }

  /*
   Shoot an arrow
   */
  void shoot(float x, float y) {    
    if (x > ((position[0]+0.5f)*defenseMap.getTileSize())) { 
      shootDirection = 1;
    } 
    else { 
      shootDirection = 0;
    }
    calculateShootAngle(x, y);
    arrowPosition[0] = (position[0]+0.5f)*defenseMap.getTileSize();
    arrowPosition[1] = ((position[1]+0.5f)*defenseMap.getTileSize())-((towerTileSize-defenseMap.tileSize)/2);
    enemyPosition[0] = x;
    enemyPosition[1] = y;
    shootingCount = millis();
    shooting = true;
    enemyLastHit = millis();
  }

  /*
   Get damage by enemy
   */
  void enemyDamage(int damage) {
    health -= damage;
    if (health < 0 && towerDestroyed == false) {
      towerDestroyed = true;
      towerDestroyCount = millis();
    }
  }

  /*
   Get description
   */
  String getDescription() {
    return "DMG: " + damage + "   FR: " + (float) fireRate/1000 + "s\n" + description;
  }

  /*
   Get repair costs
   */
  int getRepairCosts() {
    return (int) ( (1f - ((float) health / (float) maxHealth)) * (10+(currentUpdate*10)) ) + 1;
  }

  /*
   Repair
   */
  void repairTower() {
    if (defenseMap.theGui.money >= getRepairCosts() && health < maxHealth) {
      defenseMap.theGui.money -= getRepairCosts();
      health = maxHealth;
    }
  }

  /*
   Update
   */
  void updateTower() {
    if (updates > 0 && updates != currentUpdate && defenseMap.theGui.money >= ucosts[currentUpdate]) {
      damage = udamage[currentUpdate];
      fireRate = ufirerate[currentUpdate];
      fireRadius = ufireradius[currentUpdate];
      /*INTBUG*/
      costs = (int) costs + (int) ucosts[currentUpdate];
      defenseMap.theGui.money -= ucosts[currentUpdate];
      currentUpdate++;
    }
  }
}

