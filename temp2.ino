#include <Adafruit_AHT10.h>
Adafruit_AHT10 aht;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("Adafruit AHT10 demo!");
  if(!aht.begin()){
    Serial.println("Could not find AHT? Cheak wiring");
    while (1) delay(10);
  }
  Serial.println("AHT10 found");
}

void loop() {
  // put your main code here, to run repeatedly:
  sensors_event_t humidity,temp;
  aht.getEvent(&humidity,&temp);
  char Tmp[20];
  char Hum[20];
  char tmp_str[10];
  char hum_str[10];
  float tmp_val=temp.temperature;
  float hum_val=humidity.relative_humidity;
  dtostrf(tmp_val,6,2,tmp_str);
  dtostrf(hum_val,6,2,hum_str);
  sprintf(Tmp,"Temperature: %s ℃",tmp_str);
  sprintf(Hum,"Humidity: %s %% rH",hum_str);
  Serial.println(Tmp);
  Serial.println(Hum);
}
