import ketai.sensors.*;
import java.lang.Math; 

KetaiSensor sensor;
float rotationX, rotationY, rotationZ, x_position = 0, y_position = 0;

void setup() {
  new KetaiSensor(this).start();
  textAlign(CENTER, CENTER);
  textSize(50);
   orientation(LANDSCAPE);
}

void draw() {

  background(78, 93, 75);
  fill(204, 102, 0);
  rect(0,0, width, height/2);
  
  // remove/assign according  to trial
  int choose = 1;
  
  drawArrows(choose);
     
  int x_value = getXOrientation();
  int y_value = getYOrientation();
  
  // variable that stores the selection
  String selected = "";
  
   if (x_value == 0)
     {
       x_position += rotationX*100;
     }
   if (x_value == 1)
     {
       x_position += rotationX*100;
     }
   if (y_value == 0)
   {
     y_position += rotationY*100;
   }
   if (y_value == 1)
   {
     y_position += rotationY*100;
   }
    
   // if the motion in x axis is more
   if (Math.abs(x_position) > Math.abs(y_position))
   {
     if (Math.abs(x_position) > 1500)
     {
       if (x_position < 0)
       {
         print("LEFT");
         selected = "LEFT";
       }
       else
       {
         print("RIGHT");
         selected = "RIGHT";
       }
     }
   }
   else
   {
     if (Math.abs(y_position) > 1500)
     {
       if (y_position < 0)
       {
         print("TOP");
         selected = "BOTTOM";
       }
       else
       {
         print("BOTTOM");
         selected = "TOP";
       }
     }
   }

  
  fill(51);
  text("Gyroscope: \n" + 
    "x: " + nfp(rotationX, 1, 3) + "\n" +
    "y: " + nfp(rotationY, 1, 3) + "\n" +
    "z: " + nfp(rotationZ, 1, 3) + "\n" +
    selected, 0, 0, width, height);    
     
}

void onGyroscopeEvent(float x, float y, float z) {
  rotationX = x;
  rotationY = y;
  rotationZ = z;
}

/**
 * returns 0 if left, 
 *         1 if right
 *        -1 otherwise
 */
int getXOrientation() {
  return rotationX < -0.25 ? 0 : rotationX > 0.25 ? 1 : -1;
}

int getYOrientation() {
  return rotationX < -0.25 ? 0 : rotationX > 0.25 ? 1 : -1;
}


void drawArrows(int choose)
{
  stroke(51);
  if (choose == 1)
  {
    fill(100);
    arrow(width/2, height/2 - 450, 300, 0);
    fill(0);
    arrow(width/2 + 700, height/2, 400, 1.5708);
    fill(0);
    arrow(width/2, height/2 + 450, 300, 3.14159);
    fill(0);
    arrow(width/2 - 700, height/2, 400, 4.71239);
  }
    if (choose == 2)
  {
    fill(0);
    arrow(width/2, height/2 - 450, 300, 0);
    fill(100);
    arrow(width/2 + 700, height/2, 400, 1.5708);
    fill(0);
    arrow(width/2, height/2 + 450, 300, 3.14159);
    fill(0);
    arrow(width/2 - 700, height/2, 400, 4.71239);
  }
    if (choose == 3)
  {
    fill(0);
    arrow(width/2, height/2 - 450, 300, 0);
    fill(0);
    arrow(width/2 + 700, height/2, 400, 1.5708);
    fill(100);
    arrow(width/2, height/2 + 450, 300, 3.14159);
    fill(0);
    arrow(width/2 - 700, height/2, 400, 4.71239);
  }
    if (choose == 4)
  {
    fill(0);
    arrow(width/2, height/2 - 450, 300, 0);
    fill(0);
    arrow(width/2 + 700, height/2, 400, 1.5708);
    fill(0);
    arrow(width/2, height/2 + 450, 300, 3.14159);
    fill(100);
    arrow(width/2 - 700, height/2, 400, 4.71239);
  }
}


void arrow(final int aHeadX, final int aHeadY, final int aSize, final float aAngle)
{
  final float thFac = 10.0;  //thickness factor (org.:10.0)
  float sizeFac = float(aSize) / thFac;
  pushMatrix(); //make translate independent to main surface
    translate(float(aHeadX), float(aHeadY)); //recenter (x0,y0)
    rotate((aAngle));
    noStroke(); //disable border of rect
    rect(0.0-sizeFac/2.0, sizeFac/2.0, sizeFac, float(aSize)); //center
    pushMatrix(); //make rotate independent to other lines
      rotate(radians(-45.0));
      rect(0.0-sizeFac, 0.0, sizeFac, float(aSize)/2.0); //right
    popMatrix();
    pushMatrix();
      rotate(radians(45.0));
      rect(0.0, 0.0, sizeFac, float(aSize)/2.0); //left
    popMatrix();
  popMatrix();
}//void arrow(.) END
