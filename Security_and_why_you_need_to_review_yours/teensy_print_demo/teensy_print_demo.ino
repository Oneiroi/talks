/* Simple USB Keyboard Example
   Used to demonstrate Teensy duino as a keyboard at Percona Live 2014
   Author: David Busby <david.busby@percona.com>
   Copyright: Copyright 2014 Percona LLC
*/

int count = 0;

void setup() {
  Serial.begin(9600);
  delay(1000);
}

void loop() {
  char buff[] = "Hello there!\n\nThis text is being input by a Teensy Duino device,\nmasquerading as a USB keyboard ... \nWhilst this example is innocent\nit could be easily made malicious!";
  // Your computer will receive these characters from a USB keyboard.
  int len = strlen(buff);
  Keyboard.print(buff[count]);
  count++;
  delay(100);
  if (count > len){
    return;
  }
}


