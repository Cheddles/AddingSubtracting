int min=0;  //minimum value of the number line
float minLoc=0.9;  //height of the minimum value as proportion of window height
int max=10;  //maximum value of the number line
float maxLoc=0.05;  //height of the minimum value as proportion of window height

float horStartLoc=0.9;  // location of number line (starting horizontal location) for all arrows to extend left from

//int numPoints=max-min+1;  //number of points on the number line
int stepSize;  // vertical size of unit step in pixels
int maxSteps=10;  // maximum number of arithmetic steps permitted for the app
int[] steps = new int[maxSteps];  //contains the steps to be followed in order from 0-9
//int[][] points = new int[numPoints][2];  // point on the number line (recalculated each draw cycle)
//                                           // slot 0 is vertical location, slot 1 is the number line value
int stepCount=0 ;  // the number of steps contained in the current equation
//Operator testArrow = new Operator(4);
//float startHeight=0.8;  // as a proportion of window height
//float endHeight=0.05;  //as a proportion of window height

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
  stepSize=int(height*(maxLoc-minLoc)/(max-min));  // negative step size so + value goes up (negative y step)
  
//  for (int i=0; i<(max-min+1); i++){
//    points[i][0] = int(height*(map(i,min,max,startHeight,endHeight)));
//  }
  background(255);
  drawNumberLine(int(horStartLoc*width), stepSize);
  //testArrow.display();
}

//void reSize()

void drawNumberLine(int x, int yStep){
  int zeroLoc=int(height*minLoc)-min*yStep;  //vertical location of the 0 in pixels
  textAlign(LEFT, CENTER);
  textSize(height/(2*(max-min)));
  strokeWeight(3);
  stroke(0);
  fill(0);
  line(x, zeroLoc-min*stepSize, x, zeroLoc+max*stepSize);  // draw vertical line
  for(int i=min; i<(max+1); i++){  //draw tick marks for whole number locations
    line(x,zeroLoc+(i*yStep), x-width/100, zeroLoc+(i*yStep));
    text(str(i),x+width/100,zeroLoc+(i*yStep)-height/200);
  }
}
