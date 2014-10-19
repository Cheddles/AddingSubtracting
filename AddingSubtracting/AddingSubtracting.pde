int min=0;
int max=10;
int numPoints=max-min+1;  //number of points on the number line
int maxSteps=10;
int[] steps = new int[maxSteps];  //contains the steps to be followed in order from 0-9
int[][] points = new int[numPoints][2];  // point on the number line (recalculated each draw cycle)
                                           // slot 0 is vertical location, slot 1 is the number line value
int stepCount=0 ;  // the number of steps contained in the current equation
Operator testArrow = new Operator(0);
float startHeight=0.8;  // as a proportion of window height
float endHeight=0.05;  //as a proportion of window height

void setup(){
  size(800,600);
  if (frame != null) {
    frame.setResizable(true);
  }
  for (int i=0; i<(max-min+1); i++){
    points[i][1] = i+min;
  }
}

void draw(){
  for (int i=0; i<(max-min+1); i++){
    points[i][0] = int(height*(map(i,min,max,startHeight,endHeight)));
  }
  background(255);
  drawNumberLine();
  testArrow.display();
}

void drawNumberLine(){
  int xLoc=int(width*float(maxSteps+3)/(maxSteps+5));
  textAlign(LEFT, CENTER);
  textSize(height/(2*(max-min)));
  strokeWeight(3);
  stroke(0);
  fill(0);
  line(xLoc, points[0][0], xLoc, points[numPoints-1][0]);  // draw vertical line
  for(int i=0; i<numPoints; i++){  //draw tick marks for whole number locations
    line(xLoc,points[i][0], xLoc-width/100, points[i][0]);
    text(str(points[i][1]),xLoc+width/100,points[i][0]-height/200);
  }
}
