/*******************************************************
 
 Class for a tower type, just for storing information
 
 *******************************************************/

class TOWERTYPE {


  /*
  Variables
   */

  String name;
  String charSet;
  int tileSize;
  int damage;
  int fireRate;
  int fireRadius;
  boolean splashDamage;
  int splashRadius;
  float splashFactor;
  int costs;
  int maxHealth;
  String towerIcon;
  int towerIconSize;
  String description;
  float freeze;
  int updates;
  int[] ucosts;
  int[] udamage;
  int[] ufirerate;
  int[] ufireradius;
  boolean explosionAtEnemy;
  boolean hasShootingAnimation;
  float damageIncrease;

  /*
  Constructors
   */
  TOWERTYPE(String iname, String icharSet, boolean iexplosionAtEnemy, boolean ihasShootingAnimation, String itowerIcon, int itowerIconSize, int itileSize, int idamage, int ifireRate, int ifireRadius, int isplashDamage, int isplashRadius, float isplashFactor, float ifreeze, int icosts, int imaxHealth, String idescription, 
  float idamageIncrease, int iupdates, int[] iucosts, int[] iudamage, int[] iufirerate, int[] iufireradius) {
    name = iname;
    charSet = icharSet;
    tileSize = itileSize;
    damage = idamage;
    fireRate = ifireRate;
    fireRadius = ifireRadius;
    costs = icosts;
    maxHealth = imaxHealth;
    towerIcon = itowerIcon;
    towerIconSize = itowerIconSize;
    if (isplashDamage == 0) { 
      splashDamage = false;
    } 
    else { 
      splashDamage = true;
    }
    splashRadius = isplashRadius;
    splashFactor = isplashFactor;
    description = idescription;
    freeze = ifreeze;
    updates = iupdates;
    udamage = iudamage;
    ufirerate = iufirerate;
    ufireradius = iufireradius;
    ucosts = iucosts;
    explosionAtEnemy = iexplosionAtEnemy;
    hasShootingAnimation = ihasShootingAnimation;
    damageIncrease = idamageIncrease;
  } 

  TOWERTYPE(String iname, String icharSet, boolean iexplosionAtEnemy, boolean ihasShootingAnimation, String itowerIcon, int itowerIconSize, int itileSize, int idamage, int ifireRate, int ifireRadius, int isplashDamage, int isplashRadius, float isplashFactor, float ifreeze, int icosts, int imaxHealth, String idescription, 
  float idamageIncrease, int iupdates) {
    name = iname;
    charSet = icharSet;
    tileSize = itileSize;
    damage = idamage;
    fireRate = ifireRate;
    fireRadius = ifireRadius;
    costs = icosts;
    maxHealth = imaxHealth;
    towerIcon = itowerIcon;
    towerIconSize = itowerIconSize;
    if (isplashDamage == 0) { 
      splashDamage = false;
    } 
    else { 
      splashDamage = true;
    }
    splashRadius = isplashRadius;
    splashFactor = isplashFactor;
    description = idescription;
    freeze = ifreeze;
    updates = iupdates;
    explosionAtEnemy = iexplosionAtEnemy;
    hasShootingAnimation = ihasShootingAnimation;
    damageIncrease = idamageIncrease;
  }
}

