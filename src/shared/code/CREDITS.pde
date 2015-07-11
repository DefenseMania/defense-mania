/*******************************************************
 
 The Credits Menu
 
 *******************************************************/

class CREDITSMENU {

  PFont menuFont;
  BUTTON backButton;

  CREDITSMENU() {
    menuFont = createFont("bitterregular.ttf", 48);
    backButton = new BUTTON(0, "BACK", 65, height-65, 110, 26);
  }

  void display() {
    pushMatrix();
    translate(0, -height);
    backButton.display();
    textFont(menuFont, 14);
    fill(230);
    textAlign(LEFT);
    text("Developed and created by Kris Siepert.\n\nBased on Processing & ProcessingJS.\n\ncopyright (c) 2014 all rights reserved", 70, 100);
    popMatrix();
  }

  void mouseClicked() {
    if (backButton.mouseOverButton() == true) {
      theMenu.changeScreen(0);
    }
  }
}

