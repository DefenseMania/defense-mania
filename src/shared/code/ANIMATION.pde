/*******************************************************
 
 Base class for describing an animation
 
 *******************************************************/

class ANIMATION {

  /*
  Variables
   */

  /*Input*/  
  Object theObject;
  int[][] parameters;
  ANIMATIONS theAnimations;

  /*Time*/
  float animationAngle[];
  int animationStart = 0;
  float[] animationValue;
  int[] animationSub;
  int animationTime = 0;
  boolean looping = false;  

  /*
  Constructor
   */
  ANIMATION(ANIMATIONS itheAnimations, Object itheObject, int[][] iparameters) {

    /*Apply & initiate vars*/
    theAnimations = itheAnimations;
    theObject = itheObject;
    parameters = iparameters;
    animationValue = new float[parameters.length];
    animationAngle = new float[parameters.length];
    animationSub = new int[parameters.length];

    /*Set animation time & calc angle for interpolation*/
    for (int i=0; i<parameters.length; i++) {
      if (parameters[i][5] == 1) { 
        looping = true;
      }

      animationSub[i] = 0;          
      calcAngle(i);

      animationValue[i] = parameters[i][1] + animationSub[i];
      if (animationTime < parameters[i][3]+parameters[i][4]) {
        animationTime = parameters[i][3]+parameters[i][4];
      }
      animationStart = millis();
    }
  } 

  /*
  Calculate angle for linear interpolation
   */
  void calcAngle(int i) {    
    if (parameters[i][1] > parameters[i][2]) { 
      if (parameters[i][2] < 0) {
        animationSub[i] = parameters[i][2];
        parameters[i][1] += abs(parameters[i][2]);
        parameters[i][2] = 0;
      }
      animationAngle[i] = atan( (float) abs((parameters[i][2])-parameters[i][1]) / (float) parameters[i][3] );
    } 
    else {
      if (parameters[i][1] < 0) {
        animationSub[i] = parameters[i][1];
        parameters[i][2] += abs(parameters[i][1]);
        parameters[i][1] = 0;
      }   
      animationAngle[i] = atan( (float) ((parameters[i][2])-parameters[i][1]) / (float) parameters[i][3] );
    }
  }

  /*
  Start animation
   */
  void startAnim() {
    pushMatrix();   

    /*Loop through the parameters and make matrix transformations*/
    for (int i=0; i<parameters.length; i++) {

      /*Here comes the looping magic*/
      if (parameters[i][5] == 1) {       
        if (animationValue[i] == parameters[i][2]) {
          int temp = parameters[i][2];
          parameters[i][2] = parameters[i][1];
          parameters[i][1] = temp;
          animationValue[i] = parameters[i][1];
          animationStart = millis() - parameters[i][4];
          calcAngle(i);
        }
      }

      switch(parameters[i][0]) {

      case 0: /*Scale*/
        scale(animationValue[i]);
        break;

      case 1: /*Position X*/
        translate(animationValue[i], 0);
        break;

      case 2: /*Position Y*/
        translate(0, animationValue[i]);
        break;

      case 3: /*Opacity*/
        tint(255, animationValue[0]);
        break;

      case 4: /*Tint R*/
        tint(animationValue[0], 255, 255);
        break;

      case 5: /*Tint G*/
        tint(255, animationValue[0], 255);
        break;

      case 6: /*Tint B*/
        tint(255, 255, animationValue[0]);
        break;
      }

      /*Check the offset and final length and interpolate the current value*/
      if (((millis() < (animationStart+parameters[i][3]+parameters[i][4])) || parameters[i][5] == 1) && millis() > (animationStart+parameters[i][4])) {
        if (parameters[i][1] > parameters[i][2]) {
          animationValue[i] = tan(animationAngle[i]) * (float) (parameters[i][3] - (int) (millis()-(animationStart+parameters[i][4])));
        } 
        else {
          animationValue[i] = tan(animationAngle[i]) * (float) (millis()-(animationStart+parameters[i][4]));
        }
      } 


      /*If this is a negative animation add the value-offset*/
      if (animationSub[i] != 0) { 
        animationValue[i]+=animationSub[i];
      }
    }

    /*Remove the animation if it's over*/
    if (millis() >= (animationTime+animationStart) && looping == false) {
      popMatrix();
      noTint();
      theAnimations.removeAnimation(this);
    }
  }

  /*
  End animation
   */
  void endAnim() {
    popMatrix();
    noTint();
  }
}

