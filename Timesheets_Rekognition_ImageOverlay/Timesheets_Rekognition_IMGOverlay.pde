import http.requests.*;
import rekognitionupdate.faces.*;

Rekognition rekog;

PrintWriter outputTotalJSON;
PrintWriter averageJSON;

PImage img;
RekognitionUpdate[] faces;

String extension=".png";
int fileNumber=0;
int maxPhotos=3600;
boolean centerImages = true;
float deltaX, deltaY;
int hours;
String medium;


String faceinphotoAttr="\"facesinphoto:\"";
String facesinphotoIndString;


PImage[] images = new PImage[maxPhotos];


void setup() {
  size(600, 338);
  hours=hour()-12;
  if(hour()>12){
    medium = "pm";
  }
  else{
    medium = "am";
  }
  println("Started Sketch " + hours+":"+minute()+":"+second()+medium);
  // Load the API keys
  String[] keys = loadStrings("key.txt");
  String api_key = keys[0];
  String api_secret = keys[1];

  // Create the face recognizer object
  rekog = new Rekognition(this, api_key, api_secret);

  // ImageHandling
  for ( int i = 0; i< images.length; i++ )
  {
    String fileName = i + ".png";
    images[i] = loadImage(fileName);
  }
  
  println("Finished Loading Images " + hours+":"+minute()+":"+second()+medium);

  //Loop through Photos
  for (int j = 0; j< images.length; j++) {        
    String fileName = j + ".png";
    // Detect faces in image
    faces = rekog.detectFacesPath("data/"+fileName);
    //  println(faces.length);

    for (int k = 0; k < faces.length; k++) {
//      String display = "Age: " + int(faces[k].age) + "\n\n";                        // Age
//      display += "Gender: " + faces[k].gender + "\n";                               // Gender
//      display += "Gender rating: " + nf(faces[k].gender_rating, 1, 2) + "\n\n";     // Gender from 0 to 1, 1 male, 0 female
//      display += "Smiling: " + faces[k].smiling + "\n";                             // Smiling
//      display += "Smile rating: " + nf(faces[k].smile_rating, 1, 2) + "\n\n";       // Smiling from 0 to 1
//      display += "Glasses: " + faces[k].glasses + "\n";                             // Glasses
//      display += "Glasses rating: " + nf(faces[k].glasses_rating, 1, 2) + "\n\n";   // Glasses from 0 to 1
//      display += "Eyes closed: " + faces[k].eyes_closed + "\n";                               // Eyes closed
//      display += "Eyes closed rating: " + nf(faces[k].eyes_closed_rating, 1, 2) + "\n\n";     // Eyes closed from 0 to 1
//      //      text(display, faces[k].left(), faces[k].bottom()+20);                         // Draw all text below face rectangle
      if (centerImages==true) {
        deltaX=width/2-faces[k].center.x;
        deltaY=height/2-faces[k].center.y;
      } else {
        deltaX=0;
        deltaY=0;
      }
      if (j>0) {
        tint(255, 5);
      }
      image(images[j], deltaX, deltaY);
      stroke(226, 226, 226);
      strokeWeight(.25);
      noFill();
      rectMode(CENTER);
      rect(faces[k].center.x+deltaX, faces[k].center.y+deltaY, faces[k].w, faces[k].h);  // Face center, with, and height
//      fill(226, 226, 226);
//      ellipseMode(CENTER);
//      ellipse(faces[k].center.x+deltaX-faces[k].w/2, faces[k].center.y+deltaY-faces[k].h/2, 2, 2);
//      ellipse(faces[k].center.x+deltaX+faces[k].w/2, faces[k].center.y+deltaY-faces[k].h/2, 2, 2);
//      ellipse(faces[k].center.x+deltaX-faces[k].w/2, faces[k].center.y+deltaY+faces[k].h/2, 2, 2);
//      ellipse(faces[k].center.x+deltaX+faces[k].w/2, faces[k].center.y+deltaY+faces[k].h/2, 2, 2);
//      noStroke();
//      fill(150, 150, 150);
//      ellipse(faces[k].eye_right.x+deltaX, faces[k].eye_right.y+deltaY, 2, 2);              // Right eye
//      ellipse(faces[k].eye_left.x+deltaX, faces[k].eye_left.y+deltaY, 2, 2);                // Left eye
//      ellipse(faces[k].mouth_left.x+deltaX, faces[k].mouth_left.y+deltaY, 2, 2);            // Mouth Left
//      ellipse(faces[k].mouth_right.x+deltaX, faces[k].mouth_right.y+deltaY, 2, 2 );          // Mouth right
//      ellipse(faces[k].nose.x+deltaX, faces[k].nose.y+deltaY, 2, 2 );                        // Nose
//      fill(60, 60, 60);
      //    line(0, 0, faces[k].center.x+deltaX, faces[k].center.y+deltaY);
      //      text(display, 20, 20);
    }
    println("FinishedImage: "+j);
  }
  println("Finished Analysis of Images " + hours+":"+minute()+":"+second()+medium);
}

void draw() {
}

