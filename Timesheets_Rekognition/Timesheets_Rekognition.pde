import http.requests.*;
import rekognitionupdate.faces.*;

Rekognition rekog;

PrintWriter outputTotalJSON;
PrintWriter averageJSON;
PrintWriter emotionsTXT;
PrintWriter raceTXT;

PImage img;
RekognitionUpdate[] faces;

String extension=".png";
int fileNumber=2400;
int maxPhotos=3600;
int hours;
String medium;


FloatDict Emotions;
FloatDict EmotionsAvg;
FloatDict Race;
FloatDict RaceAvg;
Float raceCount;
FloatDict Age;
FloatDict Beauty;
float runningBeauty;
float runningAge;


//SETTING CUMULATIVE IMAGES VARIABLES
String JSONRunning;
String JSONStart="{\"images\":[";
String JSONImageID;
String JSONEnd="}]}";

//SETTING PER IMAGE ATTRIBUTES

String faceinphotoAttr="\"facesinphoto:\"";
String facesinphotoIndString;

String AVGJSONStart;
String emotionAttr="\"emotion\":";
String ageAttr="\"age\":";
String raceAttr="\"race\":";
String beautyAttr="\"beauty\":";


void setup() {
  size(600, 338);

  // Load the API keys
  String[] keys = loadStrings("key.txt");
  String api_key = keys[0];
  String api_secret = keys[1];
  // Create the face recognizer object
  rekog = new Rekognition(this, api_key, api_secret);

  //Create Data Categories
  Emotions= new FloatDict();
  EmotionsAvg= new FloatDict();
  Race = new FloatDict();
  RaceAvg = new FloatDict();
  Age= new FloatDict();
  Beauty= new FloatDict();
  

  //Create Data File
  outputTotalJSON = createWriter("Images.json");
  averageJSON = createWriter("Average.json");
  emotionsTXT = createWriter("Emotions.txt");
  raceTXT = createWriter("Race.txt");
  //Starting JSON
  JSONRunning=JSONStart;  
  
  hours=hour()-12;
  if(hour()>12){
    medium = "pm";
  }
  else{
    medium = "am";
  }
  println("Started Sketch " + hours+":"+minute()+":"+second()+medium);
  
  //Loop through Photos
  for (int i=fileNumber; i<maxPhotos; i++) {
    // ImageHandling
    String file = str(fileNumber) + extension;
    //    println(file);
    
    // Detect faces in image
    faces = rekog.detectFacesPath("data/"+file);
    //  println(faces.length);
//    println(faces[0].json);
    
    if (faces.length>0) {
//      println(faces.length);
      String facesinphotoIndString = faceinphotoAttr+str(faces.length)+",";
      
      JSONImageID="{\""+"image"+ str(i)+"\":";
      // println(JSONImageID+faces[0].json+"},");

      
     //SETUP STRING FOR EMOTIONS DICTIONARY
      String emotionString = faces[0].Emotion.toString();
      emotionString = emotionString.replace("{", "");  
      emotionString = emotionString.replace("}", "");
      emotionString = emotionString.replace("\n", "").replace("\r", "");
      emotionString = emotionString.replace(" ", "");
      emotionString = emotionString.replace("  ", "");
      emotionString = emotionString.replace("\"", "");
      String[] emotionParts = emotionString.split(",");
      
      //Loop Through emotionParts Array and Check to see if Emotions Dictionary Key exist.
      //If so add it to the value, else create a new key value pair.
      for (int j = 0; j<emotionParts.length; j++) {
        String[] emotionPartstwo=emotionParts[j].split(":");
        if (Emotions.hasKey(emotionPartstwo[0])==true) {
//          println("Duplicate emotion found:" + emotionPartstwo[0]);
          Emotions.set(emotionPartstwo[0], (Emotions.get(emotionPartstwo[0])+Float.parseFloat(emotionPartstwo[1])));
          Emotions.set((emotionPartstwo[0]+"count"), Emotions.get((emotionPartstwo[0]+"count"))+1);
          float emotionAverage=Emotions.get(emotionPartstwo[0])/Emotions.get((emotionPartstwo[0]+"count"));  
          EmotionsAvg.set(emotionPartstwo[0],emotionAverage);
        } else {
//          println("New Emotion found:" + emotionPartstwo[0]);
          Emotions.set(emotionPartstwo[0], Float.parseFloat(emotionPartstwo[1]));
          Emotions.set((emotionPartstwo[0]+"count"), 1);
        }
      }//END EMOTION DICT AVERAGE LOOP
//      println("Emotions = " + Emotions);
//      println("EmotionsAvg = " + EmotionsAvg);
      
      //SETUP STRING FOR RACE DICTIONARY
      String raceString = (faces[0].Race.toString()).replace("{", "").replace("}", "").replace("\"", "");
      String[] raceParts = raceString.split(": ");
      
      //DOES THE RACE DICTIONARY HAVE THE RACE IN IT?
        if (Race.hasKey(raceParts[0])==true) {
//          println("Duplicate race found:" + raceParts[0] );
          raceCount=Race.get((raceParts[0]+"count"))+1;
          Race.set((raceParts[0]+"count"),raceCount);
          Race.set(raceParts[0], Race.get(raceParts[0])+Float.parseFloat(raceParts[1]));
          float raceAverage=Race.get(raceParts[0])/Race.get((raceParts[0]+"count"));
          RaceAvg.set(raceParts[0],raceAverage);
        } else {
//          println("New race found:" + raceParts[0]);
          raceCount=1.0;
          Race.set(raceParts[0], Float.parseFloat(raceParts[1]));
          Race.set((raceParts[0]+"count"), raceCount);
        } 
      //END RACE DICT LOOP
//      println("Race = " + Race);
//      println("RaceAvg = " + RaceAvg);
      
     //SETUP STRING FOR BEAUTY DICTIONARY
      runningBeauty+=faces[0].Beauty;
      
     //SETUP STRING FOR AGE DICTIONARY
      runningAge+=faces[0].age;
      
    //println(Emotions);
    }//END IF FACES>0.
    println("FinishedImage: "+i);
    fileNumber+=1;
    //ARE WE AT THE END OF THE FOR LOOP? ADD THE APPROPRIATE END JSON CLOSE
    if (i<maxPhotos-1 && faces.length>0) {
      JSONRunning+=JSONImageID+faces[0].json+"},";
    }
    
    else if(i>=maxPhotos-1 && faces.length>0){
      JSONRunning+=JSONImageID+faces[0].json+JSONEnd;
    }
    else if(i>=maxPhotos-1 && faces.length==0){
      JSONRunning+=JSONImageID+"{}"+JSONEnd;
    }
    background(0);
    img = loadImage(file);
    //  // Draw the image
    image(img, 0, 0);
    
  }//END FOR LOOP FOR MAX PHOTOS
  
  //println(JSONRunning);  
println("Finished Analysis of Images " + hours+":"+minute()+":"+second()+medium);
//SETUP THE AVERAGES JSON
  String emotionDictToString = EmotionsAvg.toString();
  emotionDictToString = emotionDictToString.replace("FloatDict size=", "");
  emotionDictToString = emotionAttr+emotionDictToString.replace(str(EmotionsAvg.size()), "");
//  println(emotionDictToString);
  
  String raceDictToString = RaceAvg.toString();
  raceDictToString = raceDictToString.replace("FloatDict size=", "");
  raceDictToString = raceAttr+raceDictToString.replace(str(RaceAvg.size()), "");
//  println(raceDictToString);
  
  String beautyIndString = beautyAttr+str(runningBeauty/maxPhotos); 
  String ageIndString = ageAttr+str(runningAge/maxPhotos);
//  println(beautyIndString);
//  println(ageIndString);

  String averageJSONStart = "{\"average\":{";
  String averageJSONFinish = "}}";
  String JSONAvgRunning = averageJSONStart+emotionDictToString+","+raceDictToString+","+beautyIndString+","+ageIndString+averageJSONFinish;
  //OUTPUT AVERAGE JSON
  averageJSON.println(JSONAvgRunning);
  averageJSON.flush(); // Writes the remaining data to the file
  averageJSON.close(); // Finishes the file


  //OUTPUT TOTAL JSON
  outputTotalJSON.println(JSONRunning);
  outputTotalJSON.flush(); // Writes the remaining data to the file
  outputTotalJSON.close(); // Finishes the file
  
  //OUTPUT EMOTIONS DICT
  emotionsTXT.println(Emotions);
  emotionsTXT.flush(); // Writes the remaining data to the file
  emotionsTXT.close(); // Finishes the file
  
  //OUTPUT BEAUTY DICT
  raceTXT.println(Race);
  raceTXT.flush(); // Writes the remaining data to the file
  raceTXT.close(); // Finishes the file
}

void draw() {
}

