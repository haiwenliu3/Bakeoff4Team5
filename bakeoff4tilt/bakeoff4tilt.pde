import ketai.sensors.*;
import java.lang.Math; 

KetaiSensor sensor;
float rotationX, rotationY, rotationZ, x_position = 0, y_position = 0;

void setup() {
  new KetaiSensor(this).start();
  textAlign(CENTER, CENTER);
  textSize(50);
}

void draw() {

  background(78, 93, 75);
  
  fill(204, 102, 0);
  rect(0,0, width, height/2);
  
  
  int x_value = getXOrientation();
  int y_value = getYOrientation();
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
         selected = "TOP";
       }
       else
       {
         print("BOTTOM");
         selected = "BOTTOM";
       }
     }
   }
     
   //if(position > 1500)
   //  {
   //    print("one");
   //    selected = "ONE";
   //  }
   //else if (position < -1500)
   //  {
   //    print("two");
   //    selected = "TWO";
   //}
  
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
