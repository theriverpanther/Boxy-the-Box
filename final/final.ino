/*
Button
Carlos Castellanos | 2014 | ccastellanos.com
Press and release to turn an LED on, then press and release again to turn off
Note: this example works best with a momentary pushbutton or similarly biased switch
Schematic, see:
https://github.com/carloscastellanos/teaching/blob/master/Arduino/Basics/Digital/Button_schem.png
Suggestions:
- Can you make the LED go off after a certain amount of time has passed? Hint: while
  using 'delay' will work, you can also look into the 'millis' function...
- add an additional led and/or button na d increase the complexity of behaviors  
*/
// constants won't change. They're used here to set pin numbers (faster/saves memory):
const int buttonPin = 8;      // pins for button and LED
const int trigPin = 9;
const int echoPin = 10;
const int micPin = A0;

long duration;
int distance;
const int sampleWindow = 50; // Sample window width in mS (50 mS = 20Hz)
unsigned int sample;

double time = 0;
double prevTime = 0;

// store button's status - initialize to OFF (this variable will change, so it's not a const)
int buttonState = 0;
int prevButtonState = 0;
bool on = false;
void setup() {
  pinMode(buttonPin, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(micPin, INPUT);
  Serial.begin(9600);
}
void loop() {
  // read the state of the button into our variable
  buttonState = digitalRead(buttonPin);
  
  // test that state
  if (buttonState == HIGH) {      // if button is pressed...
    if(prevButtonState == LOW) {  // if it was previously not pressed
      on = !on;
      prevTime = time;
    }
  }
  time = millis();
  prevButtonState = buttonState; // save the previous button state

  // Clears the trigPin condition
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin HIGH (ACTIVE) for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance = duration * 0.034 / 2; // Speed of sound wave divided by 2 (go and back)

  unsigned long startMillis= millis();  // Start of sample window
  unsigned int peakToPeak = 0;   // peak-to-peak level

  unsigned int signalMax = 0;
  unsigned int signalMin = 1024;

   // collect data for 50 mS
   while (millis() - startMillis < sampleWindow)
   {
      sample = analogRead(micPin);
      if (sample < 1024)  // toss out spurious readings
      {
         if (sample > signalMax)
         {
            signalMax = sample;  // save just the max levels
         }
         else if (sample < signalMin)
         {
            signalMin = sample;  // save just the min levels
         }
      }
   }
   peakToPeak = signalMax - signalMin;  // max - min = peak-peak amplitude
   double volts = (peakToPeak * 5.0) / 1024;  // convert to volts
  
  // Displays the distance on the Serial Monitor
  //Serial.print("Distance: ");
  Serial.print(distance);
  //Serial.println(" cm");

  //Serial.print("Volume: ");
  Serial.print("#" + String(volts));

  double seconds = (float)(time - prevTime) / 1000.0;
  String secondsString = String(seconds);// + " seconds.";

  //Serial.print("Time Since Button Press: ");
  Serial.println("#" + String(seconds));
  //Serial.println("");
}
