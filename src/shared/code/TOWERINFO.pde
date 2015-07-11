/*******************************************************
 
 Base class for a tower info menu
 
 *******************************************************/

class TOWERINFO {

  /*
   Variables
   */
  String desc;
  THEMAP defenseMap;
  int x = width-200;
  int y = height-90;
  int w = 180;
  int h = 30;
  float rx = 10;
  float ry = 10;
  PFont font;

  /*
   Constructor
   */
  TOWERINFO(String idesc, THEMAP idefenseMap) {
    desc = idesc;
    defenseMap = idefenseMap;
    font = createFont("Arial", 10);
  }

  /*
   Update description
   */
  void updateDesc(String idesc) {
    desc = idesc;
  }

  /*
   Display
   */
  void display() {

    translate(-defenseMap.centerX, -defenseMap.centerY);

    pushMatrix();
    translate(-((width-w-20)*(defenseMap.theGui.guiScale-1))-(((w+20)*defenseMap.theGui.guiScale)-(w+20)), -((height-(h+60))*(defenseMap.theGui.guiScale-1))-(((h+60)*defenseMap.theGui.guiScale)-(h+60)));
    scale(defenseMap.theGui.guiScale);

    noStroke();
    fill(0, 160);

    defenseMap.theAnimations.animate(this);

    beginShape();
    vertex(x, y+ry);
    bezierVertex(x, y, x, y, x+rx, y);

    vertex(x+w-rx, y); 
    bezierVertex(x+w, y, x+w, y, x+w, y+ry);

    vertex(x+w, y+h-ry);
    bezierVertex(x+w, y+h, x+w, y+h, x+w-rx, y+h);

    vertex(x+rx, y+h);
    bezierVertex(x, y+h, x, y+h, x, y+h-ry);

    endShape(CLOSE);

    fill(255);      

    textFont(font);
    textLeading(14);
    text(desc, x+5, y+12); 

    popMatrix();

    defenseMap.theAnimations.animateEnd(this);
  }
}

