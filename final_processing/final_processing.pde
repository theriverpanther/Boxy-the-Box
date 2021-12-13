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
int timeSinceMovement = 0;
int timeTalking = 0;
SoundFile laughTrack;
SoundFile shutdown;
SoundFile death;

SoundFile[] buttonSounds;
SoundFile[] micSounds;
SoundFile[] movementSounds;

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
  
  buttonSounds = new SoundFile[]{
    new SoundFile(this,"Sounds/make-turn-quicker.mp3"),
    new SoundFile(this,"Sounds/ouch.mp3"),
    new SoundFile(this,"Sounds/pushing-buttons.mp3")
  };
  micSounds = new SoundFile[]{
    new SoundFile(this,"Sounds/cut-the-chit-chat.mp3"),
    new SoundFile(this,"Sounds/boring.mp3"),
    new SoundFile(this,"Sounds/shut-up.mp3")
  };
  movementSounds = new SoundFile[]{
    //new SoundFile(this,"Sounds/now-you-move.mp3"),
    new SoundFile(this,"Sounds/play-faster.mp3"),
    new SoundFile(this,"Sounds/sit-there.mp3"),
    new SoundFile(this,"Sounds/dont-have-all-day.mp3")
  };
  
  currSound = laughTrack;
}
void draw(){
  if (!currSound.isPlaying()) {//!sound.isPlaying()) { 
    if(soundCooldown > 0) {
      soundCooldown -= millis() - time;
    }
    
    int rand = (int)(Math.random() * 3);
    //Button pressed
    if(buttonTimeVal == 0 && time > 2000) {
      currSound = buttonSounds[rand];
      currSound.play();
      soundCooldown = 500;
      timeSinceMovement = 0;
      timeTalking = 0;
    }
    
    //Loud volume
    if(volumeVal > 130) {
      timeTalking += millis() - time;
    }
    //Distance far
    if(distanceVal > 10) {
      timeSinceMovement += millis() - time;
    }
    
    if(timeSinceMovement > 30000) {
      currSound = movementSounds[rand];
      currSound.play();
      soundCooldown = 2000;
      timeSinceMovement = 0;
      timeTalking = 0;
    }
    else if(timeTalking > 7500) {
      currSound = micSounds[rand];
      currSound.play();
      soundCooldown = 2000;
      timeSinceMovement = 0;
      timeTalking = 0;
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
    }
}

int FormatReading(String reading) {
  if (reading == null)
    return 0;
  
  // trim off any whitespace:
  reading = trim(reading);
  // convert to an int and map to the screen height:
  int val = int(reading);
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
  val = map(val, 0, 5, 0, 1023);
  return val;
}
