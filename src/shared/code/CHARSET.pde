/*******************************************************
 
 Class for storing a single charset
 
 *******************************************************/

class CHARSET {

  /*
  Variables
   */
  PImage theCharSet;
  PImage[][] charSetParts;
  String charSetFile;
  int tilesize;
  THEMAP defenseMap;

  /*
  Constructor
   */
  CHARSET(String icharSetFile, THEMAP idefenseMap, int itilesize) {
    tilesize = itilesize;
    defenseMap = idefenseMap;
    charSetFile = icharSetFile;
    theCharSet = loadImage(defenseMap.mapPath + "/data/" + charSetFile);
    if (tilesize != -1) {
      createParts();
    }
  }

  /*
  Create Parts
   */
  void createParts() {
    if (theCharSet.width != 0) {
      int l = (int) (theCharSet.width/tilesize);
      int b = (int) (theCharSet.height/tilesize);     
      charSetParts = new PImage[l][b];
      for (int i = 0; i < l; i++) {
        for (int j = 0; j < b; j++) {
          charSetParts[i][j] = theCharSet.get(i*tilesize, j*tilesize, tilesize, tilesize);
        }
      }
    }
  }

  /*
  Get the charset
   */
  PImage getCharSet() {
    return theCharSet;
  }

  /*
  Get the charset
   */
  PImage getCharSet(int x, int y) {
    if (charSetParts != null) {
      return charSetParts[x][y];
    } 
    else {
      /*Create again. The browser often has to be told twice before he makes this*/
      createParts();
      return theCharSet.get(x*tilesize, y*tilesize, tilesize, tilesize);
    }
  }
}

