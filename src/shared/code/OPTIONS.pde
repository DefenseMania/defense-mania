/*******************************************************
 
 The Options Menu
 
 *******************************************************/

class OPTIONSMENU {

  PFont menuFont;
  BUTTON backButton;
  BUTTON hqButton;
  BUTTON fpsButton;
  BUTTON aaButton;

  OPTIONSMENU() {
    menuFont = createFont("bitterregular.ttf", 48);
    backButton = new BUTTON(0, "BACK", 65, height-65, 110, 26);
    hqButton = new BUTTON(1, "HQ GRAPHICS", 65, 65, 160, 26);
    aaButton = new BUTTON(1, "ENABLE AA", 65, 140, 160, 26);
    fpsButton = new BUTTON(1, "SHOW FPS", 65, 215, 160, 26);
  }

  void display() {
    pushMatrix();
    translate(0, -2*height);
    backButton.display();
    hqButton.display();
    aaButton.display();
    fpsButton.display();
    textFont(menuFont, 14);    
    fill(230);
    text("Click to enable high quality graphics:\nthis costs a lot of performance.", 260, 70);
    text("Click to enable Anti Aliasing:\nthis costs even more performance.", 260, 145); 
    text("Click to show the current framerate\nper second.", 260, 220);    
    popMatrix();
  }

  void mouseClicked() {
    if (backButton.mouseOverButton() == true) {
      theMenu.changeScreen(0);
    } 
    else if (hqButton.mouseOverButton() == true) {
      if (hqButton.isActive == false) {
        hqButton.isActive = true;
        highGraphicsQuality = true;
      } 
      else {
        hqButton.isActive = false;
        highGraphicsQuality = false;
      }
    } 
    else if (aaButton.mouseOverButton() == true) {
      if (aaButton.isActive == false) {
        aaButton.isActive = true;
        antiAliasing = true;
      } 
      else {
        aaButton.isActive = false;
        antiAliasing = false;
      }
    }
    else if (fpsButton.mouseOverButton() == true) {
      if (fpsButton.isActive == false) {
        fpsButton.isActive = true;
        showFps = true;
      } 
      else {
        fpsButton.isActive = false;
        showFps = false;
      }
    }
  }
}

