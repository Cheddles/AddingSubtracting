// this class contains an arrow for adding or subtracting an integer amount. The arrow is who (up for +, down for -)
// along with the value displayed along its side.
// to form this arrow, the user drags a point from the location on the number line that represents the running total
// of the equation.

class Operator{
  boolean forming;
  int start;  // value (on the number line) of the base of the arrow
  int value;  // size and direction of the arrow
  float xLoc;  // horizontal location of the arrow (as proportion of window width
  boolean selected;
  
  Operator(int startValue){
    start=startValue;
  }
  
  void display(){
    drawArrow();
  }
  
  boolean contains(){
    boolean retVal=false;
    return retVal;
  }
  
  void form(int y){
    
  }
  
  void drawArrow(){
    //(location[0], location[1], value*scale, bearing, lineWeight);
    if (value>0){  // up arrow
      //line(
    }
//    // draw label
//    if (bearing<=PI){
//      pushMatrix();
//        translate(location[0], location[1]);
//        rotate(bearing-PI/2);
//        textAlign(CENTER, CENTER);
//        textSize(lineWeight*4);
//        fill(0);
//        if (bearing<0.5*PI){
//          text(label, value*scale/2, -lineWeight*4);
//        } else{
//          text(label, value*scale/2, lineWeight*3);
//        }
//      popMatrix();
//    } else {
//      pushMatrix();
//        translate(location[0], location[1]);
//        rotate(bearing+PI/2);
//        textAlign(CENTER, CENTER);
//        textSize(lineWeight*4);
//        fill(0);
//        if (bearing<1.5*PI){
//          text(label, -value*scale/2, lineWeight*3);
//        } else{
//          text(label, -value*scale/2, -lineWeight*4);
//        }
//      popMatrix();
//    }
  }
  
}
