#Timesheets#

###What it is###

Over the course of the last year (June 2014-June 2015), I have been recording my face as I've been completing my timesheets at Smart Design, in hopes of getting a better understanding of my mood and behavior performing this repetitive task.

As a summary for my performance review evaluation, I spliced together all the video into a timelapse video available here

markbreneman.github.io/timesheets

and ran facial recognition on all the video, to build data files which would document my emotions, race, age and "beauty" for the year.  Lastly I also took stills from the video and aligned the detected faces into aggregate imagery of what it might mean to try and capture the timesheets experience in a more abstracted nature over time.

![First 200](/media/0-200.png "Images 0-200")
![First 1200](/media/1200.png "Images 0-1200")
![First 2400](/media/2400.png "Images 0-2400")

They end up being quite scary;



###How it works###

####Attribution####
This project is built on the shoulders of giants. It uses a slightly modified automator script from [Kyle McDonald](https://github.com/kylemcdonald) to record a users face when they visit a website, and a modified [Rekognition to Processing library](https://github.com/shiffman/Rekognition-for-Processing) from [Daniel Schiffman](https://github.com/shiffman). The processing code is my own(cause who else would write something so absurd), and is separated out into two files; one for the aggregate image overlays and one for the data file recording. It could definetly be optimized into one sketch.

####Workflow####
I had the scripts setup to run and record anytime I visited the SmartWorks website. With the videos recorded overtime I compiled them in Final Cut into one 5 hour long video. Then compressed them into a time lapse of 2 min.  Then exported all the frames; 3600 PNG files and renamed them numerically so each was #.png .  Those PNG files were then placed into the data folder of each Processing Sketch.  The Processing sketches were then run using a modified Rekognition-for-Processing library that I modified in Eclipse(reference the Rekognition for Processing -mb folder in this repo.) and analysis was done using the [Rekognition Face Detection API](https://rekognition.com/demo/face).  All the PNGs were too much for github so I've removed them, but the end data files are located in the [Results folder](https://github.com/markbreneman/timesheets/tree/master/Timesheets_Rekognition/Results) as JSON Data.

###To do it yourself###

The modified automator scripts are located in the recording scripts folder, and can be modified with automator to work on any website (change the lines - 'set targetDomain to "domaintoRecord"`)

and browser of your choice(change the lines - `tell application "application name"`).

Once the script is set to record go about your normal behaviors and it will record and save to the specified folder(on the line - `set folderName to (path to desktop as text) & "folderNameDesired"`).  
With the video saved the next thing to do is [register for API keys with Rekognition](https://rekognition.com/user/create), and place them in the [key.txt files in the sketch folders](https://github.com/markbreneman/timesheets/blob/master/Timesheets_Rekognition/key.txt).  Next you'll have to compile the Rekognition-for-Processing-mb library in Eclipse(sorry but thats life).  There's good walk through here;[Processing Library template](https://github.com/processing/processing-library-template).  Lastly put save the video into images using Final Cut or FFMPEG etc. and place them in the Data folders.  Then run the Processing Sketches and await the fun times.
