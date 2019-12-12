import ketai.sensors.*;

KetaiSensor sensor;
float rotationX, rotationY, rotationZ, position = height/2;

void setup() {
  new KetaiSensor(this).start();
  textAlign(CENTER, CENTER);
  textSize(50);
}

void draw() {

  background(78, 93, 75);
  
  fill(204, 102, 0);
  rect(0,0, width, height/2);
  
  
  int value = getOrientation();
   if (value == 0)
     {
       position += 100;
     }
   if (value == 1)
     {
       position -= 100;
     }
   
   String selected = "";
   
   if(position > 1500)
     {
       print("one");
       selected = "ONE";
     }
   else if (position < -1500)
     {
       print("two");
       selected = "TWO";
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
int getOrientation() {
  return rotationX < -0.25 ? 0 : rotationX > 0.25 ? 1 : -1;
}
