/*******************************************************
 
 Base class for handling animations
 
 *******************************************************/

class ANIMATIONS {

  /*
   Variables
   */
  ArrayList anims;

  /*
  Constructor
   */
  ANIMATIONS() {
    anims = new ArrayList();
  }

  /*
  Add animation
   */
  void addAnimation(Object itheObject, int[][] iparameters) {
    anims.add( new ANIMATION(this, itheObject, iparameters) );
  }


  /*
  Remove animation
   */
  void removeAnimation(Object iani) {
    for (int i=0; i<anims.size(); i++) {
      ANIMATION temp = (ANIMATION) anims.get(i);
      if ( temp.equals(iani) == true || temp.theObject.equals(iani) == true) {      
        temp = null;
        anims.remove(i);
        break;
      }
    }
  }


  /*
  Global call method
   */
  void animate(Object iobject) {
    for (int i=0; i<anims.size(); i++) {
      ANIMATION temp = (ANIMATION) anims.get(i);
      if ( temp.theObject.equals(iobject) == true ) {
        temp.startAnim();
        break;
      }
    }
  }

  /*
  Global call end method
   */
  void animateEnd(Object iobject) {
    for (int i=0; i<anims.size(); i++) {
      ANIMATION temp = (ANIMATION) anims.get(i);
      if ( temp.theObject.equals(iobject) == true ) {
        temp.endAnim();
        break;
      }
    }
  }
}

