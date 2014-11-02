int min=-10;  //minimum value of the number line
float minLoc=0.9;  //height of the minimum value as proportion of window height
float eqnHeight=0.95;  // height of equation steps display
int max=10;  //maximum value of the number line
float maxLoc=0.02;  //height of the minimum value as proportion of window height

float horStartLoc=0.85;  // location of number line (starting horizontal location) for all arrows to extend left from

int stepSize;  // vertical size of unit step in pixels
//int xStepSize;
//int xStart;  // centred location of "={answer}"
int zeroLoc;   //vertical location of the 0 in pixels
int maxSteps=20;  // maximum number of arithmetic steps permitted for the app
int[] steps = new int[maxSteps];  //contains the steps to be followed in order from 0-9
int stepCount=0 ;  // the number of steps contained in the current equation
int dragLoc;  // horizontal location of double-headed arrow (if drawn)

boolean formingNew = false;  // true if currently dragging a new arrow step
boolean verbose=false;  // whether the equation at the bottom should be written in verbose +(-2) format or traditional abbreviated -2 format

String test="testing";

void setup(){
  size(800,600);
  if (frame != null) {
    frame.setResizable(true);
  }
  strokeCap(SQUARE);
}

void draw(){

  int runningTotal=0;  // total of equation (working backwards)
  int total=0;  // total of equation (used to calculate initial arrow spacing)
  String equation="";  // used too determine spacing of each step arrow.
  int xCurrent;  // used to step left while determining arrow location
  float equationWidth=0;  // width (in pixels) of equation between mid-points of end terms
  float stepWidth[]=new float[stepCount];  // width in pixels of each step
  String stepText[]=new String[stepCount];  // string of each step including brackets if in verbose mode
    
  // recalculate values that depend on window size (in case of user-resize
  stepSize=int(height*(maxLoc-minLoc)/(max-min));  // negative step size so + value goes up (negative y step)
  zeroLoc=int(height*minLoc)-min*stepSize;  //vertical location of the 0 in pixels
  int xNumLine=int(horStartLoc*width);  // x-coordinate of number line (from which arrows are spaced
  int progWidth=xNumLine;  //progressive location (in pixels) of equation being drawn (to centre of end element)
  
  background(255);
  textSize(height/15);  // required to calculate the correct spacing using textWidth function
  if(verbose){
    progWidth=progWidth-int(textWidth("+(-88)")/2);
  } else{
    progWidth=progWidth-int(textWidth("-88")/2);
  }
  
  dragLoc=progWidth;  //location of the dragging arrow for step creation
  
  // determine total sum and width of equation text
  for (int i=0; i<stepCount; i++){
    // calculate width of each equation step
    if(verbose){
      stepText[i]="+("+str(steps[i])+")";
    } else{
      if (steps[i]>=0){
        stepText[i]="+"+str(steps[i]);
      }else{
        stepText[i]=str(steps[i]);
      }
    }
    textSize(height/15);
    stepWidth[i]=textWidth(stepText[i]);
    equation=equation+stepText[i];
    total=total+steps[i];
    runningTotal=total;
  }
  if (formingNew){
    total=total-steps[stepCount-1];
    steps[stepCount-1]=formStep(mouseY, zeroLoc+(total*stepSize));
    total=total+steps[stepCount-1];
    runningTotal=total;
  }
  // draw screen elements
  if (stepCount==0){  // if no equation steps, draw "blank" screen
    drawNumberLine(min, max, zeroLoc, xNumLine, stepSize, 0);
    drawDoubleArrow(progWidth, zeroLoc);
  }else{
    // draw grid lines here
    drawNumberLine(min, max, zeroLoc, xNumLine, stepSize, int(textWidth(equation)));
    if(!formingNew){  // draw double arrow if required
      drawDoubleArrow(progWidth, zeroLoc+total*stepSize);
      progWidth=progWidth-int(textWidth("="+str(total))/2);
      fill(0);
      stroke(0);
      textAlign(CENTER, CENTER);
      textSize(height/15);
      text("="+str(total), dragLoc, eqnHeight*height);
      progWidth=progWidth-int(textWidth("="+str(total))/2);
    }else{
      fill(0);
      stroke(0);
      textAlign(LEFT, CENTER);
      textSize(height/15);
      text("="+str(total), xNumLine, eqnHeight*height);
      progWidth=progWidth+int(stepWidth[stepCount-1]/2);
    }
    
    //draw arrows and steps
    for(int i=(stepCount-1); i>-1; i--){
      progWidth=progWidth-int(stepWidth[i]/2);
      fill(0);
      stroke(0);
      textAlign(CENTER,CENTER);
      textSize(height/15);
      text(stepText[i],progWidth,eqnHeight*height);
      drawStep(runningTotal-steps[i], steps[i], zeroLoc, stepSize, progWidth);
      strokeWeight(2);
      stroke(0);
      if(i<stepCount-1) line(progWidth,zeroLoc+runningTotal*stepSize,progWidth+(stepWidth[i]+stepWidth[i+1])/2,zeroLoc+runningTotal*stepSize);
      else line(progWidth,zeroLoc+runningTotal*stepSize,progWidth+(stepWidth[i]+int(textWidth("="+str(total))))/2,zeroLoc+runningTotal*stepSize);
      progWidth=progWidth-int(stepWidth[i]/2);
      runningTotal=runningTotal-steps[i];
    }
  }
}

void mousePressed(){
  //int xStepSize=150;  //temp
  int total=0;
  for(int i=0; i<stepCount; i++){  //go through all values to find running total
    total=total+steps[i];
  }
  if ((overStart(mouseX, mouseY, dragLoc , total, zeroLoc, stepSize))&&(stepCount<maxSteps)){
    stepCount++;
    formingNew=true; 
  }
}

void mouseReleased(){
  formingNew=false;
}

void drawNumberLine(int min,    // minimum value of number line
                    int max,    // maximum value of number line
                    int zero,// y-coordinate of 0
                    int x,      // x-coordinate of number line
                    int yStep,  // number of pixels (vertical) per number line unit
                    float gridWidth){  // width of the gridlines
  textAlign(LEFT, CENTER);
  textSize(height/(2*(max-min)));
  strokeWeight(3);
  stroke(0);
  fill(0);
  line(x, zero+min*stepSize, x, zero+max*stepSize);  // draw vertical line
  for(int i=min; i<(max+1); i++){  //draw tick marks for whole number locations
//    strokeWeight(1);
//    stroke(200);
//    line(x-gridWidth,zero+(i*yStep),x,zero+(i*yStep));
    strokeWeight(3);
    stroke(0);
    line(x,zero+(i*yStep), x-width/100, zero+(i*yStep));
    text(str(i),x+width/100,zero+(i*yStep)-height/200);
  }
}

void keyPressed() {
  if (!formingNew&&(stepCount>0)&&((keyCode == BACKSPACE)||(keyCode == DELETE))) {
    stepCount--;
  }
}

boolean overStart(int x,  // current x-coordinate of the mouse
                  int y,  // current y-coordinate of the mouse
                  int xTarget,  // x-coordinate of the target spot
                  int yVal,  //y value of target
                  int zero,  // y-coordinate of 0
                  int yStep){  // number of vertical pixels per step
  //int runningTotal=0;
  int rSquared;
  
//  if (stepCount>0){
//    for (int i=0; i>stepCount; i++){
//      runningTotal=runningTotal+steps[0];
//    }
//  }
  rSquared=(x-xTarget)*(x-xTarget)+(y-zero-(yVal*yStep))*(y-zero-(yVal*yStep));
  test=str(rSquared);
  if (rSquared<(yStep*yStep)){
    return true;
  } else {
    return false;
  }
}

int formStep(int y,
             int yStart){
  int returnVal;  //the value to be returned
  if (y<(zeroLoc+max*stepSize)) y=(zeroLoc+max*stepSize);
  if (y>(zeroLoc+min*stepSize)) y=(zeroLoc+min*stepSize);
  if (formingNew){
    if (yStart>y) return int(((float(y)-yStart)/stepSize)+0.5);
    else return int(((float(y)-yStart)/stepSize)-0.5);
  }else{
    return steps[stepCount-1];
  }
}

void drawStep(int start,  // value of base of arrow 
              int value,  // size and direction of arrow
              int yZero,  // y-coordinate of 0
              int yStep,  // pixels per unit (up is positive)
              int xLoc){  // x-coordinate of arrow
  //int xStepSize=150;  //temp
  int headLength=max(value/2, height/30);
  if (value>=0){
    stroke(0);
    fill(0);
  }else{
    stroke(255,0,0);
    fill(255,0,0);
  }
  strokeWeight(width/200);
  if (value==0){
    ellipseMode(CENTER);
    ellipse(xLoc,yZero+(yStep*start),yStep/2,yStep/2);
  }else if (value<0){
    line(xLoc,yZero+(yStep*start),xLoc,yZero+(yStep*(start+value))-headLength);
    noStroke();
    for(int i=-1; i>value; i--){
      ellipse(xLoc, yZero+yStep*(start+i), yStep/3, yStep/3);
    }
    pushMatrix();
      translate(xLoc,yZero+(yStep*(start+value)));
      arrowHead(false, headLength);
      translate(0, -yStep*value/2);
      rotate(-PI/2);
      textSize(height/20);
      textAlign(CENTER);
      fill(0);
      text(str(value),0,yStep/2);
    popMatrix();
  }else{
    strokeWeight(width/200);
    line(xLoc,yZero+(yStep*start),xLoc,yZero+(yStep*(start+value))+headLength);
    noStroke();
    for(int i=1; i<value; i++){
      ellipse(xLoc, yZero+yStep*(start+i), yStep/3, yStep/3);
    }
    pushMatrix();
      translate(xLoc,yZero+(yStep*(start+value)));
      arrowHead(true, headLength);
      translate(0, -yStep*value/2);
      rotate(-PI/2);
      textSize(height/20);
      textAlign(CENTER);
      fill(0);
      text("+"+str(value),0,yStep/2);
    popMatrix();
  }
}
  
void arrowHead(boolean up, int headLength){
  noStroke();
  if (up){
    //upright arrowhead
    beginShape();
      vertex(0,0);
      vertex(-headLength/3,headLength);
      vertex(headLength/3,headLength);
    endShape(CLOSE);
  }else{
    //inverted arrowhead
    beginShape();
      vertex(0,0);
      vertex(-headLength/3,-headLength);
      vertex(headLength/3,-headLength);
    endShape(CLOSE);
  }
}

void drawDoubleArrow(int x, int y){
  // draw non-counting, double-headed arrow to invite creation of a new step
    stroke(100);
    strokeWeight(3);
    line(x,y+(0.5*stepSize),x,y-(0.5*stepSize));
    pushMatrix();
      translate(x,y+stepSize);
      arrowHead(false, 3*stepSize/4);
      translate(0,-2*stepSize);
      arrowHead(true, 3*stepSize/4);
    popMatrix();
}
