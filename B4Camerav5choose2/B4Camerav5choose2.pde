import java.util.ArrayList;
import java.util.Collections;
//import ketai.sensors.*;
//KetaiSensor sensor;
import ketai.camera.*;
KetaiCamera cam;
PImage img;
int r;
int g;
int b;

float rSD;
float gSD;
float bSD;

String[] colors = {"Red", "Green"}; // COLOR NAMES CORRESPOND TO RGB VALUES ON NEXT LINE (whites, grays, and yellow seem to be BAD)
int[][] rgbs = { {210,0,0}, {0,137,13} }; // put values here based on rgb camera reading in DEBUGGING MODE
ArrayList history = new ArrayList<Integer>();
String confirmedColor = "None";
String currentColor = "";

boolean debug = false; // change this to true when you want to look at the rbgs and standard deviations of a new physical color

//Font
PFont font;
int cameraScale;

int chooseStage = 4;

// ============= HIS CODE FOR TRIALS =====
private class Target
{
  int target = 0;
  int action = 0;
}

int trialCount = 10; //this will be set higher for the bakeoff
int trialIndex = 0;
ArrayList<Target> targets = new ArrayList<Target>();

int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
boolean userDone = false;
int countDownTimerWait = 0;

boolean secondStageCorrect = false;
boolean firstStageCorrect = false;

void setup() {
  size(2280,1080); // CHANGE THIS TO PHONE RESOLUTION    size(longer,shorter)    for landscape
  frameRate(30);
  orientation(LANDSCAPE);
  textFont(createFont("Arial", 96));
  cameraScale = 3;
  cam = new KetaiCamera(this, width/cameraScale, height/cameraScale, 24);
  //image(cam,0,0);
  rectMode(CENTER);
  textFont(createFont("Arial", 40)); //sets the font to Arial size 20
  font = createFont("Arial", 40);
  textAlign(CENTER);
  noStroke(); //no stroke
  
  for (int i=0; i<trialCount; i++)  //don't change this!
  {
    Target t = new Target();
    t.target = ((int)random(1000))%4;
    t.action = ((int)random(1000))%2;
    targets.add(t);
    //println("created target with " + t.target + "," + t.action);
  }
  
  
  cam.start();
}

void draw() {
  int index = trialIndex;
  background(255);
  
  if (startTime == 0)
    startTime = millis();

  if (index>=targets.size() && !userDone)
  {
    userDone=true;
    finishTime = millis();
  }

  if (userDone)
  {
    textAlign(CENTER);
    stroke(0);
    fill(0);
    text("User completed " + trialCount + " trials", width/2, height/2);
    text("User took " + nfc((finishTime-startTime)/1000f/trialCount, 2) + " sec per target", width/2, height*.7);
    return;
  }
  
  fill(0);
  textAlign(LEFT);
  rectMode(CORNER);
  stroke(0);
  textFont(font, 100);
  
  if (chooseStage == 4) // PUT THE UI FOR CHOOSE 4 STAGE HERE 
  {
    textFont(font, 100);
    fill(0);
    stroke(0);
    text("Target: "+(targets.get(index).target+1), width*.03 , height*.1);
    text("Trial: "+(index+1)+"/"+trialCount, width*.03 , height*.2);
    
    line(width/4,0,width/4,height);
    line(2*width/4,0,2*width/4,height);
    line(3*width/4,0,3*width/4,height);
  }
  
  if (cam.isStarted() && chooseStage == 2 && !debug)
  {
    currentColor = getColor();
    //text(bestColorOption(color(r,g,b)), width*.9 , height*.9);
    text("Target: "+colors[targets.get(index).action], width*.03 , height*.1);
    text("Trial: "+(index+1)+"/"+trialCount, width*.03 , height*.2);
    image(cam, width*.03, height*.3);
    fill( color(r,g,b) );
    rect(width*.03, height*.4+height/cameraScale, (width/cameraScale)*.85, 300);
    drawColor2UI();
    
    if (currentColor != "None")
    {
      getConfirmed();
    }
    
    if (confirmedColor != "None" && chooseStage == 2)
    {
      checkNextTrial2();
    }
    
    
  }
  if (debug)
  {
      currentColor = getColor();
      if (currentColor != "None")
      {
        getConfirmed();
      }
      drawDebug();
  }
  
  
  
  
}

void drawColor2UI()
{
  float tileSize = height*0.55;
  float centerX = width*.65;
  float centerY = height*.5+tileSize/2;
  int targetOption = targets.get(trialIndex).action;
  //First tile
  fill(color(rgbs[0][0], rgbs[0][1], rgbs[0][2]));
  rect(centerX-tileSize, centerY-tileSize, tileSize, tileSize);
  
  //Second tile
  fill(color(rgbs[1][0], rgbs[1][1], rgbs[1][2]));
  rect(centerX, centerY-tileSize, tileSize, tileSize);
  
  ////Third tile
  //fill(color(rgbs[2][0], rgbs[2][1], rgbs[2][2]));
  //rect(centerX-tileSize, centerY, tileSize, tileSize);
  
  ////Third tile
  //fill(color(rgbs[3][0], rgbs[3][1], rgbs[3][2]));
  //rect(centerX, centerY, tileSize, tileSize);
  
  if (targetOption == 0)
    drawTargetCircle(centerX-tileSize/2, centerY-tileSize/2, tileSize);
  else if (targetOption == 1)
    drawTargetCircle(centerX+tileSize/2, centerY-tileSize/2, tileSize);
  //else if (targetOption == 2)
  //  drawTargetCircle(centerX-tileSize/2, centerY+tileSize/2, tileSize);
  //else if (targetOption == 3)
  //  drawTargetCircle(centerX+tileSize/2, centerY+tileSize/2, tileSize);
  ////rect(width*.7, height*.5,4,4);
}

void drawTargetCircle(float xCen, float yCen, float tile)
{
  stroke(0);
  strokeWeight(20);
  fill(255);
  ellipse(xCen, yCen, tile/2.5, tile/2.5);
  strokeWeight(1);
  fill(0);
}

void drawDebug()
{
  background(255);
  
  text("stdevs: "+rSD+", "+gSD+", "+bSD, width*.4 , height*.2);
  text("Sum of st. devs: "+(rSD+gSD+bSD), width*.4 , height*.3);
  text("Confirmed: "+confirmedColor, width*.4 , height*.5);
  text("Current: "+currentColor, width*.4 , height*.6);
  String col = r+", "+g+", "+b;
  text( "RGB avg: "+col, width*.4 , height*.8);
  text( "Hue: "+hue(color(r,g,b)), width*.4 , height*.9);
  
  textFont(font, 100);
  text("Target: "+colors[targets.get(trialIndex).action], width*.03 , height*.1);
  text("Trial: "+(trialIndex+1)+"/"+trialCount, width*.03 , height*.2);
  image(cam, width*.03, height*.3);
  fill( color(r,g,b) );
  rect(width*.1, height*.9, 200,200);
  
}

void checkNextTrial2()
{
  if (confirmedColor == colors[targets.get(trialIndex).action])
  {
    secondStageCorrect = true;
    //trialIndex++;
    println("CORRECT COLOR");
  }
  else
  {
    secondStageCorrect = false;
    //if (trialIndex >0)
    //  trialIndex--;
    // make sure to go back to start of trial
    println("IN-CORRECT COLOR");
  }
  if (firstStageCorrect && secondStageCorrect)
  {
    trialIndex++;
  }
  
  resetConfimred();
  chooseStage = 4;
}

void getConfirmed()
{
  if (rSD + gSD + bSD < 2000) // MAY NEED TO CHANGE THRESHOLD FOR SUM OF SD (the code only calcs sd's when it recognizes the color, so first put rgb calibration, then check for sd's)
  {
    confirmedColor = currentColor;
  }
  else
  {
    confirmedColor = "None";
  }
}

String bestColorOption(color camColor)
{
  float distance;
  float bestDistance = 1000000;
  String endColor="None";
  float thres = 10000;
  for (int i =0; i<2; i++)
  {
    color optionColor = color(rgbs[i][0],rgbs[i][1],rgbs[i][2]);
    distance = ( red(camColor) -red(optionColor)) * ( red(camColor) -red(optionColor)) + ( green(camColor) -green(optionColor))* ( green(camColor) -green(optionColor)) + ( blue(camColor) -blue(optionColor))* ( blue(camColor) -blue(optionColor));
    //println("Distance to "+colors[i]+": "+distance);
    if (distance < thres && distance < bestDistance)
    {
      endColor=colors[i];
    }
    if (distance < bestDistance)
    {
      bestDistance = distance;
    }
      
  }
  return endColor;
  
}

String getColor()
{
  int total=0;
  for (int i=0; i<cam.pixels.length; i=i+5)
  {
    r+=red(cam.pixels[i]);
    g+=green(cam.pixels[i]);
    b+=blue(cam.pixels[i]);
    total++;
  }
  
  r=r/total;
  g=g/total;
  b=b/total;
  
  String best = bestColorOption(color(r,g,b));
  
  if (best != "None")
  {
    rSD = sdColor("Red", cam.pixels, r);
    gSD = sdColor("Green", cam.pixels, g);
    bSD = sdColor("Blue", cam.pixels, b);
    //getConfirmed();
    //if (confirmedColor != "None" && chooseStage == 4)
    //{
    //  checkNextTrial4();
    //}
  }
  
  return best;
}

// ========== HELPER FUNCTIONS ===========================
int findMode(ArrayList<Integer> array)
{
    int mode = array.get(0);
      int maxCount = 0;
      for (int i = 0; i < array.size(); i++) {
          int value = array.get(i);
          int count = 0;
          for (int j = 0; j < array.size(); j++) {
              if (array.get(j) == value) count++;
              if (count > maxCount) {
                  mode = value;
                  maxCount = count;
                  }
              }
      }
      if (maxCount > 1) {
          return mode;
      }
      return 4;
}
float sdColor(String col, color[] pix, float m)
{
  float mean = m;
  float sumOfDiff = 0.0;
  float colour =0;
  float n = 0;
   for (int y = 0; y < pix.length; y=y+8){
       if (col == "Red")
         colour = red(pix[y]) - mean;
       else if (col == "Green")
         colour = green(pix[y]) - mean;
       else if (col == "Blue")
         colour = blue(pix[y]) - mean;
         
       sumOfDiff += Math.pow(colour, 2); 
       n++;
    }
  return sumOfDiff / (n - 1);
}
// ===================================================

void onCameraPreviewEvent() {
  cam.read();
}

void resetConfimred()
{
  confirmedColor = "None";
}

void checkNext4(boolean correct) // MODIFY THIS TO CHECK IF BOTH STAGES WERE CORRECT AFTER CHOOSE 2
{
  firstStageCorrect = correct;
  chooseStage = 2;
}

void mousePressed() {
  //if (confirmedColor != "None")
  //{
  //  resetConfimred();
  //}
  int quad = mouseX / (width/4);
  if (chooseStage  == 4)
  {
    println("Q",quad);
    if (targets.get(trialIndex).target == quad)
    {
       checkNext4(true);
       println("CORRECT 4 option");
    }
    else
    {
      checkNext4(false);
      println("IN-CORRECT 4 option");
    }
  }

  
  //if (! cam.isFlashEnabled())
  //{
  //  //cam.stop();
  //  cam.enableFlash();
  //}
  //else
  //  cam.disableFlash();
  //  //cam.start();
}
