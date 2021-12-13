import processing.sound.*;
import processing.serial.*;

SoundFile sound;
Serial arduinoPort;

final int portIndex = 0;
int soundCooldown = 0;
int distanceVal = 0;
float volumeVal = 0;
int buttonTimeVal = 0;
int time = 0;
SoundFile laughTrack;
SoundFile shutdown;
SoundFile death;
SoundFile currSound;

void setup(){
  size(800,800);
  background(255);
  String portName = Serial.list()[portIndex];
  println(portName);
  arduinoPort = new Serial(this, portName, 9600);
  arduinoPort.bufferUntil('\n');
  time = millis();
  
  laughTrack = new SoundFile(this, "sitcom-laughing-1.mp3");
  shutdown = new SoundFile(this, "windows_xp_shutdown.mp3");
  death = new SoundFile(this, "roblox-death-sound_1.mp3");
  currSound = laughTrack;
}
void draw(){
  if (!currSound.isPlaying()) {//!sound.isPlaying()) { 
    if(soundCooldown > 0) {
      soundCooldown -= millis() - time;
    }
    
    //Button pressed
    if(buttonTimeVal == 0 && time > 2000) {
      currSound = death;
      currSound.play();
      soundCooldown = 500;
    }
    //Loud volume
    else if(volumeVal > 200) {
      currSound = laughTrack;
      currSound.play();
      soundCooldown = 2000;
    }
    //Distance far
    else if(distanceVal > 10 && distanceVal < 100) {
      currSound = shutdown;
      currSound.play();
      soundCooldown = 2000;
    }
  }
  
  time = millis();
}
void serialEvent(Serial port) {
  // get the ASCII string:
    
    String reading = port.readStringUntil('\n');
    if (reading != null) {
      distanceVal = /*FormatReading*/int(reading.split("#")[0]);
      volumeVal = FormatReadingFloat(reading.split("#")[1]);
      buttonTimeVal = /*FormatReading*/int(reading.split("#")[2]);
      
      //println(distanceVal);// = /*FormatReading*/int(reading.split("#")[0]);
      //println(volumeVal);// = FormatReading(reading.split("#")[1]);
      //println(buttonTimeVal);// = /*FormatReading*/int(reading.split("#")[2]);
    }
}

int FormatReading(String reading) {
  if (reading == null)
    return 0;
  
  // trim off any whitespace:
  reading = trim(reading);
  // convert to an int and map to the screen height:
  int val = int(reading);
  //println(sensorReading);
  val = int(map(val, 0, 5, 0, 1023));
  return val;
}
float FormatReadingFloat(String reading) {
  if (reading == null)
    return 0;
  
  // trim off any whitespace:
  reading = trim(reading);
  // convert to an int and map to the screen height:
  float val = float(reading);
  //println(sensorReading);
  val = map(val, 0, 5, 0, 1023);
  return val;
}
