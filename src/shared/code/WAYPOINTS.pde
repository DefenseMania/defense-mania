/*******************************************************
 
 Load and manage waypoints for enemy-movement
 
 *******************************************************/

class WAYPOINTS {

  /*
  Variables
   */
  XML xmlData; /*XML Object*/
  int[] startPoint = new int[2]; /*Coords of the start point*/
  int[] endPoint = new int[2]; /*Coords of the end point*/
  int[][] wayPoints; /*All the waypoints*/

  /*
  Constructor
   */
  WAYPOINTS(String mapFile) {    

    /*Load waypoints.xml into an array*/
    xmlData = loadXML(mapFile + "/waypoints.xml");    
    XML[] xmlWayPoints = xmlData.getChildren("waypoints/waypoint");
    wayPoints = new int[xmlWayPoints.length-2][2];    
    for (int i=0;i<xmlWayPoints.length;i++) {

      String temp = xmlWayPoints[i].getContent();
      String[] temp2 = temp.split(",");

      if (i==0) { 
        startPoint[0] = parseInt(temp2[0]); 
        startPoint[1] = parseInt(temp2[1]);
      } 
      else if (i==xmlWayPoints.length-1) { 
        endPoint[0] = parseInt(temp2[0]); 
        endPoint[1] = parseInt(temp2[1]);
      }
      else {
        wayPoints[i-1][0] = parseInt(temp2[0]); 
        wayPoints[i-1][1] = parseInt(temp2[1]);
      }
    }
  }

  /*
  Get startpoint
   */
  int[] getStart() {
    return startPoint;
  }

  /*
  Get endpoint
   */
  int[] getEnd() {
    return endPoint;
  }

  /*
  Get waypoint
   */
  int[][] getWP() {
    return wayPoints;
  }
}

