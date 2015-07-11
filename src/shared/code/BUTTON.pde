/*******************************************************
 
 Base class for making beautiful menu buttons
 
 *******************************************************/

class BUTTON {

  /*
 Variables
   */
  String buttonText;
  int w;
  int h;
  int x;
  int y;
  int scrollOffset = 0;
  boolean isMouseOver = false;
  boolean isMouseClick = false;
  boolean isActive = false;
  boolean isLocked = false;
  PFont buttonFont;
  int type;

  /*
 Constructor
   */
  BUTTON(int itype, String ibuttonText, int ix, int iy, int iw, int ih) {

    /*Apply all the values & initiate vars*/
    buttonFont = createFont("bitterregular.ttf", 48);
    buttonText = ibuttonText;
    type = itype;
    x = ix;
    y = iy;
    w = iw;
    h = ih;
  }

  /*
 
   */
  boolean mouseOverButton() {
    if (mouseXp >= x && mouseXp <= x+w && mouseYp >= y+scrollOffset && mouseYp <= y+h+scrollOffset) {
      return true;
    } 
    else {
      return false;
    }
  }

  /*
 Check if the mouse is over the button and set boolean values
   */
  void mouseOver() {
    if (mouseXp >= x && mouseXp <= x+w && mouseYp >= y+scrollOffset && mouseYp <= y+h+scrollOffset) {
      if (mousePressed == true) {
        isMouseClick = true;
        isMouseOver = false;
      } 
      else {
        isMouseOver = true;
        isMouseClick = false;
      }
    } 
    else {
      isMouseOver = false;
      isMouseClick = false;
    }
  }

  /*
 Display the button
   */
  void display() {  

    mouseOver();

    if (theAnimations != null) {
      theAnimations.animate(this);
    }

    imageMode(CORNER);
    textAlign(CENTER); 

    /*Locked button*/
    if (isLocked == true) {
      if (type != 3) {
        stroke(255, 100);
        line(x, y+h-1, x+w, y+h-1);
        if (type == 1) { 
          line(x, y-1, x+w, y-1);
        }
        line(x, y+h, x+w, y+h);
        if (type == 1) { 
          line(x, y, x+w, y);
        }
      }
      fill(255, 100);

      /*Active button*/
    } 
    else if (isActive == true) {
      if (type != 3) {
        stroke(#89f9ff);
        line(x, y+h-1, x+w, y+h-1);
        if (type == 1) { 
          line(x, y-1, x+w, y-1);
        }
        stroke(#001807);
        line(x, y+h, x+w, y+h);
        if (type == 1) { 
          line(x, y, x+w, y);
        }
      }
      fill(#89f9ff);

      /*Mouse clicking on the button*/
    } 
    else if (isMouseClick == true) {
      fill(#89f9ff);

      /*Mouse hovers the button*/
    } 
    else if (isMouseOver == true) {
      if (type != 3) {
        stroke(#89f9ff);
        line(x, y+h-1, x+w, y+h-1);
        if (type == 1) { 
          line(x, y-1, x+w, y-1);
        }
        stroke(#001807);
        line(x, y+h, x+w, y+h);
        if (type == 1) { 
          line(x, y, x+w, y);
        }
      }
      fill(255);

      /*Standard button*/
    } 
    else {
      fill(255, 190);
      if (type != 3) {
        stroke(#f8ddc2);
        line(x, y+h-1, x+w, y+h-1);
        if (type == 1) { 
          line(x, y-1, x+w, y-1);
        }
        stroke(#251002);
        line(x, y+h, x+w, y+h);
        if (type == 1) { 
          line(x, y, x+w, y);
        }
      }
    }

    /*Draw the Text*/
    if (type == 3) { 
      textFont(buttonFont, 18);
    } 
    else { 
      textFont(buttonFont, 24);
    }
    text(buttonText, x+(w/2), y+(h/2)+8);
    textAlign(LEFT);

    if (theAnimations != null) {
      theAnimations.animateEnd(this);
    }
  }
}

