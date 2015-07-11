	/*******************************************************
	 
	 BASE CLASS: "Defense Mania"
	 
	 *******************************************************/

	
	/*******************************************************
	 
	 Global variables
	 
	 *******************************************************/
	
	float menuScale = 1;
	float hudScale = 1;
	int globalPlatform = 2;
	
	/*******************************************************
	 
	 Set the whole thing up
	 
	 *******************************************************/
	
	void setup() {
	
	  //Set size, orientation & framerate
	  size(960, 600);
	  frameRate(60);
	
	  //Load fonts & set title
	  fpsFont = createFont("Arial", 48);    
	
	  //Initialise main game objects
	  theAnimations = new ANIMATIONS();
	  theMenu = new MENU(0, false);
	  
	}
	
	/*******************************************************
	 
	 It's time to draw some fancy stuff
	 
	 *******************************************************/
	
	void draw() {
	
          mouseXp = (int) (mouseX/scaleFactor);
          mouseYp = (int) (mouseY/scaleFactor);
	  globalDisplay();
	  
	}
	
	/*******************************************************
	 
	 Input
	 
	 *******************************************************/
	
	/*
	 MouseReleased only for Menu-Buttons
	 */
	void mouseReleased() { 
	  if (theMenu != null) {
	    theMenu.mouseClicked();
	  }
	}
	
	/*
	 MouseClicked
	 */
	void mouseClicked() {
	  if (inputHandler != null) {
	    if (mouseButton == LEFT) {
	      inputHandler.mouseClick();
	    }
	  }
	}
	
	/*
	 MouseDragged
	 */
	void mouseDragged() {
	  if (inputHandler != null) {
	    if (mouseButton == RIGHT) {
	      inputHandler.scroll((mouseX-pmouseX)*0.7, (mouseY-pmouseY)*0.7);
	    }
	  }
	  if (theMenu != null) {
	  	if(mouseButton == RIGHT) {
	  	  theMenu.scroll((mouseY-pmouseY)*0.7);
	  	}
	  }
	}
	
	
	/*******************************************************
	 
	 Fancy JS Additions
	 
	 *******************************************************/
	
	
	Collection Collections = new Collection();
	
	class Collection {
	
	Collection() {
	
	}
	
	void sort(ArrayList inputList, Object inputObject) {
		if(inputObject instanceof displayComparator) {
			inputList.sort(displaySortFunction);
		} else if(inputObject instanceof enemyComparator) {
			inputList.sort(enemySortFunction);
		}
	}
	
	}
	
	function displaySortFunction(o1, o2) {
		float position1 = 0;
	      float position2 = 0;
	     
	      if(o1 instanceof TOWER) {
	        TOWER temp = (TOWER) o1;
	        position1 = (temp.position[1]+0.5f) * defenseMap.tileSize;
	      } else {
	        ENEMY temp = (ENEMY) o1;
	        if(temp.enemyDied == false && temp.enemyAlive == false && (temp.moveDirection == 1 || temp.moveDirection == 2)) {
	          position1 = -50;
	        } else {
	          position1 = temp.position[1];
	        }
	      }
	      
	      if(o2 instanceof TOWER) {
	        TOWER temp = (TOWER) o2;
	        position2 = (temp.position[1]+0.5f) * defenseMap.tileSize;
	      } else {
	        ENEMY temp = (ENEMY) o2;
	        if(temp.enemyDied == false && temp.enemyAlive == false && (temp.moveDirection == 1 || temp.moveDirection == 2)) {
	          position2 = -50;
	        } else {        
	          position2 = temp.position[1];
	        }
	      }
	
	      return (int) (position2-position1);
	}
	
	function enemySortFunction(enemy1, enemy2) {
		int returnVar = 0;
	    returnVar = (int) (enemy2.moveComplete - enemy1.moveComplete);
	    return returnVar;	
	}
