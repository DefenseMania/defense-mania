/*******************************************************
 
 Class for managin charsets to optimize memory usage
 
 *******************************************************/

class CHARSETS {

  /*
  Variables
   */
  ArrayList charSets;
  THEMAP defenseMap;

  /*
Constructor
   */
  CHARSETS(THEMAP idefenseMap) {
    defenseMap = idefenseMap;
    charSets = new ArrayList();
  }

  /*
 Add a charset
   */
  void addCharSet(String charSetFile, int tileSize) {
    boolean foundCharSet = false;
    for (int i = 0; i < charSets.size(); i++) {
      CHARSET tempChar = (CHARSET) charSets.get(i); 
      if (tempChar.charSetFile == charSetFile) {
        foundCharSet = true;
        break;
      }
    }
    if (foundCharSet == false) {
      charSets.add(new CHARSET(charSetFile, defenseMap, tileSize));
    }
  }

  /*
 Get a charset
   */
  PImage getCharSet(String charSetFile) {
    PImage temp = null;
    for (int i = 0; i < charSets.size(); i++) {
      CHARSET tempChar = (CHARSET) charSets.get(i); 
      if ((String) tempChar.charSetFile == (String) charSetFile) {     
        temp = tempChar.getCharSet();
        break;
      }
    }
    return temp;
  }

  /*
 Get a charset-part
   */
  PImage getCharSetPart(String charSetFile, int x, int y) {
    PImage temp = null;
    for (int i = 0; i < charSets.size(); i++) {
      CHARSET tempChar = (CHARSET) charSets.get(i); 
      if ((String) tempChar.charSetFile == (String) charSetFile) {     
        temp = tempChar.getCharSet(x, y);
        break;
      }
    }
    return temp;
  }
}

