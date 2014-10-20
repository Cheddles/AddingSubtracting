int min=-10;  //minimum value of the number line
float minLoc=0.9;  //height of the minimum value as proportion of window height
int max=10;  //maximum value of the number line
float maxLoc=0.02;  //height of the minimum value as proportion of window height

float horStartLoc=0.85;  // location of number line (starting horizontal location) for all arrows to extend left from

int stepSize;  // vertical size of unit step in pixels
int maxSteps=10;  // maximum number of arithmetic steps permitted for the app
int[] steps = new int[maxSteps];  //contains the steps to be followed in order from 0-9
int stepCount=0 ;  // the number of steps contained in the current equation

boolean formingNew = false;  // true if currently dragging a new arrow step

void setup(){
  size(800,600);
  if (frame != null) {
    frame.setResizable(true);
  }
//  for (int i=0; i<(max-min+1); i++){
//    points[i][1] = i+min;
//  }
}

void draw(){
  // recalculate values that depend on window size (in case of user-resize
  stepSize=int(height*(maxLoc-minLoc)/(max-min));  // negative step size so + value goes up (negative y step)
  int zeroLoc=int(height*minLoc)-min*stepSize;  //vertical location of the 0 in pixels
  int xStart=int(horStartLoc*width);  // x-coordinate of number line (from which arrows are spaced
  
  background(255);
  drawNumberLine(min, max, zeroLoc, xStart, stepSize);
  

}

void mouseDown(){
  if (overStart(mouseX, mouseY), zeroLoc, stepSize){
    //start new arrow
  }
}

void drawNumberLine(int min,    // minimum value of number line
                    int max,    // maximum value of number line
                    int zero,// y-coordinate of 0
                    int x,      // x-coordinate of number line
                    int yStep){ // number of pixels (vertical) per number line unit
  
  textAlign(LEFT, CENTER);
  textSize(height/(2*(max-min)));
  strokeWeight(3);
  stroke(0);
  fill(0);
  line(x, zero+min*stepSize, x, zero+max*stepSize);  // draw vertical line
  for(int i=min; i<(max+1); i++){  //draw tick marks for whole number locations
    line(x,zero+(i*yStep), x-width/100, zero+(i*yStep));
    text(str(i),x+width/100,zero+(i*yStep)-height/200);
  }
}

boolean overStart(int x,  // current x-coordinate of the mouse
                  int y,  // current y-coordinate of the mouse
                  int xTarget,  // x-coordinate of the target spot
                  int zero,  // y-coordinate of 0
                  int yStep){  // number of vertical pixels per step
  int runningTotal=0;
  
  if (stepCount>0){
    for (int i=0; i>stepCount; i++){
      runningTotal=runningTotal+steps[0];
    }
  }
  
}
