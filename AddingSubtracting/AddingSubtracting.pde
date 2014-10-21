int min=-10;  //minimum value of the number line
float minLoc=0.9;  //height of the minimum value as proportion of window height
float eqnHeight=0.95;  // height of equation steps display
int max=10;  //maximum value of the number line
float maxLoc=0.02;  //height of the minimum value as proportion of window height

float horStartLoc=0.9;  // location of number line (starting horizontal location) for all arrows to extend left from

int stepSize;  // vertical size of unit step in pixels
int xStepSize;
int xStart;
int zeroLoc;
int maxSteps=8;  // maximum number of arithmetic steps permitted for the app
int[] steps = new int[maxSteps];  //contains the steps to be followed in order from 0-9
int stepCount=0 ;  // the number of steps contained in the current equation

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
  int runningTotal=0;  //
  
  // recalculate values that depend on window size (in case of user-resize
  stepSize=int(height*(maxLoc-minLoc)/(max-min));  // negative step size so + value goes up (negative y step)
  xStepSize=int(width/(maxSteps+2));  // number of horizontal pixels between arrows and number line
  zeroLoc=int(height*minLoc)-min*stepSize;  //vertical location of the 0 in pixels
  xStart=int(horStartLoc*width);  // x-coordinate of number line (from which arrows are spaced
  
  background(255);
  drawNumberLine(min, max, zeroLoc, xStart, stepSize);
  
  // drawStep(2,0, zeroLoc, stepSize, xStart-2*xStepSize, color(255,0,0));  // temp testing arrow
  
  
  for (int i=0; i<stepCount; i++){
    //draw arrows
    if((formingNew)||(stepCount==maxSteps)){
      drawStep(runningTotal, steps[i], zeroLoc, stepSize, xStart-(stepCount-i)*xStepSize, color(255,0,100));
      fill(0);
      textSize(height/25);
      textAlign(CENTER,CENTER);
      text("+"+str(steps[i]), xStart-(stepCount-i)*xStepSize, height*eqnHeight);
    } else{
      drawStep(runningTotal, steps[i], zeroLoc, stepSize, xStart-(stepCount-i+1)*xStepSize, color(255,0,100));
      fill(0);
      textSize(height/25);
      textAlign(CENTER,CENTER);
      text("+("+str(steps[i])+")", xStart-(stepCount-i+1)*xStepSize, height*eqnHeight);
    }
    runningTotal=runningTotal+steps[i];
  }
  
  if((formingNew)||(stepCount==maxSteps)){
    steps[stepCount-1]=formStep(mouseY, zeroLoc+((runningTotal-steps[stepCount-1])*stepSize));
    //draw equation total under number line
    textSize(height/20);
    textAlign(CENTER,CENTER);
    text("="+str(runningTotal), xStart, height*eqnHeight);
  } else {
    // draw non-counting, double-headed arrow to invite creation of a new step
    stroke(100);
    strokeWeight(3);
    line((xStart-xStepSize),(zeroLoc+((runningTotal+0.5)*stepSize)),(xStart-xStepSize),(zeroLoc+((runningTotal-0.5)*stepSize)));
    pushMatrix();
      translate(xStart-xStepSize,zeroLoc+((runningTotal-1)*stepSize));
      arrowHead(true, 3*stepSize/4);
    popMatrix();
    pushMatrix();
      translate(xStart-xStepSize,zeroLoc+((runningTotal+1)*stepSize));
      arrowHead(false, 3*stepSize/4);
    popMatrix();
    // draw running total under the new step arrow
    fill(0);
    textSize(height/20);
    textAlign(CENTER,CENTER);
    text("="+str(runningTotal), xStart-xStepSize, height*eqnHeight);
  }
  //text(test,300,100);
}

void mousePressed(){
  int total=0;
  for(int i=0; i<stepCount; i++){  //go through all values to find running total
    total=total+steps[i];
  }
  if ((overStart(mouseX, mouseY, (xStart-xStepSize), total, zeroLoc, stepSize))&&(stepCount<maxSteps)){
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
                    int yStep){ // number of pixels (vertical) per number line unit
  
  textAlign(LEFT, CENTER);
  textSize(height/(2*(max-min)));
  strokeWeight(3);
  stroke(0);
  fill(0);
  line(x, zero+min*stepSize, x, zero+max*stepSize);  // draw vertical line
  for(int i=min; i<(max+1); i++){  //draw tick marks for whole number locations
    strokeWeight(1);
    stroke(200);
    if (formingNew) line(x-stepCount*xStepSize,zero+(i*yStep), x, zero+(i*yStep));
    else line(x-(stepCount+1)*xStepSize,zero+(i*yStep), x, zero+(i*yStep));
    strokeWeight(3);
    stroke(0);
    line(x,zero+(i*yStep), x-width/100, zero+(i*yStep));
    text(str(i),x+width/100,zero+(i*yStep)-height/200);
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
  if (formingNew){
    return int((y-yStart-0.5)/stepSize);
  }else{
    return steps[stepCount-1];
  }
}

void drawStep(int start,  // value of base of arrow 
              int value,  // size and direction of arrow
              int yZero,  // y-coordinate of 0
              int yStep,  // pixels per unit (up is positive)
              int xLoc,   // x-coordinate of arrow
              color colour){  // colour of arrow
  int headLength=max(value/2, height/30);
  strokeWeight(2);
  stroke(0);
  line(xLoc,yZero+(yStep*(start+value)),xLoc+xStepSize,yZero+(yStep*(start+value)));
  stroke(colour);
  fill(colour);
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
      textSize(xStepSize/3);
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
      textSize(xStepSize/3);
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
