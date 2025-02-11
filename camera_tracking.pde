
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
 import processing.net.*;
 
 Client myClient;
String dataIn;
Capture video;
OpenCV opencv;  //Create an instance of the OpenCV library.
 
Serial serial; // The serial port
 
//Variables for keeping track of the current servo positions.
int servoTiltPosition;
int servoPanPosition;
//The pan/tilt servo ids for the Arduino serial command interface.
char tiltChannel = 0;
char panChannel = 1;
 
//These variables hold the x and y location for the middle of the detected face.
int midFaceY=0;
int midFaceX=0;
 
//The variables correspond to the middle of the screen, and will be compared to the midFace values
int midScreenY = (height/2);
int midScreenX = (width/2);
int midScreenWindow = 10;  //This is the acceptable 'error' for the center of the screen. 
 
//The degree of change that will be applied to the servo each time we update the position.
int stepSize=1;
 
void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
 
  video.start();
 
  printArray(Serial.list());
 
   myClient = new Client(this, "192.1.0.13", 13579);     // T computer ip and star automation port
  //serial = new Serial(this, "/dev/ttyUSB0", 57600);   // for serial communication
 
}
 
 
 
void draw() {
  
    
 if (myClient.available() > 0) {           // it reads the reply from T computer
dataIn = myClient.readString();


//String servoTiltPosition11 = dataIn.substring(405,410);   // it reads the tilt from t computer - feedback
//String servoPanPosition11 = dataIn.substring(391,396);    // it reads the pan from t computer - feedback

//servoTiltPosition = Integer.valueOf(servoTiltPosition11);            ///it converts string to integer
//servoPanPosition = Integer.valueOf(servoPanPosition11);

//println(servoTiltPosition);
//println(servoPanPosition);
 }
  scale(2);
  opencv.loadImage(video);
 
  image(video, 0, 0 );
 
  noFill();
  stroke(53, 204, 255);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
 // println(faces.length);                      // number of faces detected
 
  for (int i = 0; i < faces.length; i++) { 
   // println(faces[i].x + "," + faces[i].y);                   // prints the x,y of camera tracking
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
   
  }
  
    
    
  if(faces.length > 0){
   // If a face was found, find the midpoint of the first face in the frame.
    //NOTE: The .x and .y of the face rectangle corresponds to the upper left corner of the rectangle,
    //      so we manipulate these values to find the midpoint of the rectangle.
    
    midFaceY = faces[0].y-50);
   midFaceX = faces[0].x -100);
   print(midFaceY);            //  it is referencing the tracking to the middle of the video image
   print(",");
   println(midFaceX);
  
  
  
  
 if(midFaceY < (midScreenY - midScreenWindow)){
   
   String camera = "\"2\"";
    String pan0 = "\"0\"";
    String pan1 = "\"15\"";
    String pan11 = "\"-15\"";
    String tilt0 = "\"0\"";
    String tilt1 = "\"15\"";
    String tilt11 = "\"-15\"";
    
     
       myClient.write("<TRIM CAM=" + camera + " " + "PAN=" + pan0 + " " + "TILT=" + tilt1 + "/>\n");      // command from processing to t computer.It moves the tilt 15 degrees
      
     delay(1);
     
    }
    //Find out if the Y component of the face is above the middle of the screen.
    else if(midFaceY > (midScreenY + midScreenWindow)){
      
      
    String camera = "\"2\"";
    String pan0 = "\"0\"";
    String pan1 = "\"15\"";
    String pan11 = "\"-15\"";
    String tilt0 = "\"0\"";
    String tilt1 = "\"15\"";
    String tilt11 = "\"-15\"";
    
    
       // println("tilt up");
    myClient.write("<TRIM CAM=" + camera + " " + "PAN=" + pan0 + " " + "TILT=" + tilt11 + "/>\n");
    
   delay(1);

    }
    //Find out if the X component of the face is to the left of the middle of the screen.
    if(midFaceX < (midScreenX - midScreenWindow)){
   String camera = "\"2\"";
    String pan0 = "\"0\"";
    String pan1 = "\"15\"";
    String pan11 = "\"-15\"";
    String tilt0 = "\"0\"";
    String tilt1 = "\"15\"";
    String tilt11 = "\"-15\"";
    
   
      myClient.write("<TRIM CAM=" + camera + " " + "PAN=" + pan11 + " " + "TILT=" + tilt0 + "/>\n");
       
delay(1);
      
  
    
   
    }
    //Find out if the X component of the face is to the right of the middle of the screen.
   else if(midFaceX > (midScreenX + midScreenWindow)){
     
   String camera = "\"2\"";
    String pan0 = "\"0\"";
    String pan1 = "\"15\"";
    String pan11 = "\"-15\"";
    String tilt0 = "\"0\"";
    String tilt1 = "\"15\"";
    String tilt11 = "\"-15\"";
    
       
       myClient.write("<TRIM CAM=" + camera + " " + "PAN=" + pan1 + " " + "TILT=" + tilt0 + "/>\n");
      
  
           delay(1);


  

  }
  



  }


  
  }

  
  
  

 
void captureEvent(Capture c) {
 
  c.read();
}
