#include <Wire.h>
#include <SFE_ISL29125.h>


// Declare sensor, servomotors, and incoming data from MATLAB
SFE_ISL29125 RGB_sensor;


void setup() {
  // Initialize serial communication
  Serial.begin(115200);

  // Initialize the ISL29125 with simple configuration so it starts sampling
  if (RGB_sensor.init()); {
    Serial.println("Sensor Initialization Successful\n\r");
  }
  
}

// Read sensor values for each color and print them to serial monitor
void loop() {
  // Read sensor values (16 bit integers)
  unsigned int R = RGB_sensor.readRed();
  Serial.println(R);
  unsigned int G = RGB_sensor.readGreen();
  Serial.println(G);
  unsigned int B = RGB_sensor.readBlue();
  Serial.println(B);
  
  delay(1000);
}

