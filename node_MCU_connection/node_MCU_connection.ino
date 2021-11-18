/*
  Software serial multple serial test

 Receives from the hardware serial, sends to software serial.
 Receives from software serial, sends to hardware serial.

 The circuit:
 * RX is digital pin 2 (connect to TX of other device)
 * TX is digital pin 3 (connect to RX of other device)

 Note:
 Not all pins on the Mega and Mega 2560 support change interrupts,
 so only the following can be used for RX:
 10, 11, 12, 13, 50, 51, 52, 53, 62, 63, 64, 65, 66, 67, 68, 69

 Not all pins on the Leonardo support change interrupts,
 so only the following can be used for RX:
 8, 9, 10, 11, 14 (MISO), 15 (SCK), 16 (MOSI).

 created back in the mists of time
 modified 25 May 2012
 by Tom Igoe
 based on Mikal Hart's example

 This example code is in the public domain.

 */
#if defined(ESP32)
#include <WiFi.h>
#include <FirebaseESP32.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#endif

#include <ArduinoJson.h>

#include <SoftwareSerial.h>

//Pinos de comunicacao serial com a ST Núcleo
#define Pin_ST_NUCLEO_RX    5  //Pino D1 da placa Node MCU
#define Pin_ST_NUCLEO_TX    4  //Pino D2 da placa Node MCU
//Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Dados Relativos"
#define WIFI_PASSWORD "P3rnambuco"

/* 2. If work with RTDB, define the RTDB URL and database secret */
#define DATABASE_URL "https://ping-74a1b.firebaseio.com/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
#define DATABASE_SECRET "3ollozKFNBvN9EHrwgNHmmg2ajnoOLsJFTQZVMpr"

/* 3. Define the Firebase Data object */
FirebaseData fbdo;

/* 4, Define the FirebaseAuth data for authentication data */
FirebaseAuth auth;

/* Define the FirebaseConfig data for config data */
FirebaseConfig config;

unsigned long dataMillis = 0;
int count = 0;
int Acid = 0;
int Temp = 0;
int Umid = 0;
int Wind = 0;
int stm_input = 0;
char json_input[50];
char current_key[10];
char current_value[10];
char on_key = 0;
int char_posix = 0;
int topper_value = 0;
int seeds = 0;

FirebaseJson Fjson;

SoftwareSerial SSerial(Pin_ST_NUCLEO_RX, Pin_ST_NUCLEO_TX);

void setup()
{
  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
      Serial.print(".");
      delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the certificate file (optional) */
  //config.cert.file = "/cert.cer";
  //config.cert.file_storage = StorageType::FLASH;

  /* Assign the database URL and database secret(required) */
  config.database_url = DATABASE_URL;
  config.signer.tokens.legacy_token = DATABASE_SECRET;

  Firebase.reconnectWiFi(true);

  /* Initialize the library with the Firebase authen and config */
  //Firebase.begin(&config, &auth);

  //Or use legacy authenticate method
  Firebase.begin(DATABASE_URL, DATABASE_SECRET);
  
  // Open serial communications and wait for port to open:
  Serial.begin(115200);
  SSerial.begin(115200);

  Serial.println("Serial by hardware!");

  // set the data rate for the SoftwareSerial port
  SSerial.println("Serial by software!");
}

void loop() // run over and over
{
  if (SSerial.available()){
    //Serial.write(SSerial.read());
    int raw_byte = SSerial.read();
    char letter = raw_byte;
    
    if(letter == '{'){
      on_key = 1;
    }

    if(letter == ':'){
        on_key = 0;
    }

    if(letter != ' ' && letter != '\n' && letter != '{' && letter != '}' && letter != ':'){    
      json_input[char_posix] = letter;
      char_posix += 1;

      if(letter == ','){
        on_key = 1;
        char parameter_name[50] = "/parameters/";
        strcat(parameter_name, current_key);
        int parsed_value = atoi(current_value);
        Serial.printf("%s : %d\n", parameter_name, parsed_value);
        Fjson.set(current_key, current_value);
        //Firebase.setInt(fbdo, parameter_name, current_key);
        //Serial.printf("Set int... %s\n", Firebase.setString(fbdo, parameter_name, current_value) ? "ok" : fbdo.errorReason().c_str());
        //delay(1000);
        strncpy(current_key, "", strlen(current_key));
        strncpy(current_value, "", strlen(current_value));
      }
      else{
        if(on_key){
          strncat(current_key, &letter, 1);
        }
        else{
          strncat(current_value, &letter, 1);
        }
      }

    }

    if(letter == '}'){
      Serial.printf("\n");
      Fjson.toString(Serial,true);
      int temp_seed;
      Firebase.getInt(fbdo, "/parameters/Seeds", &temp_seed);
      Fjson.set("Seeds", temp_seed);
      Serial.printf("Set int... %s\n", Firebase.setJSON(fbdo, "/parameters", Fjson) ? "ok" : fbdo.errorReason().c_str());
    }
  }
  else{
    int new_topper = topper_value;
    Firebase.getInt(fbdo, "/parameters/Topper", &new_topper);
    if (new_topper != topper_value){
      topper_value = new_topper;
      if(topper_value == 0){
        SSerial.write('t');
      }
    }
  
    int current_seed;
    Firebase.getInt(fbdo, "/parameters/Seeds", &current_seed);
    if (current_seed != seeds){
      char parsed_seed[30];
      sprintf(parsed_seed, "%d", current_seed);
      Serial.printf("valor de parsed: %s\n", parsed_seed);
      char pass_serial[13] = "s";
      strcat(pass_serial, parsed_seed);
      SSerial.write(pass_serial);
      seeds = current_seed;
    }
    
  }


  if (Serial.available())
    SSerial.write(Serial.read());


//  if (millis() - dataMillis > 5000){
//    dataMillis = millis();
//    int teste = 0;
//    Firebase.getInt(fbdo, "/Teste", &teste);
//    
//    //Serial.println(stm_input, DEC);
//    //Serial.printf("teste value %d\n", teste);
//    //Serial.printf("Set int... %s\n", Firebase.setInt(fbdo, "/Params/Topper", count++) ? "ok" : fbdo.errorReason().c_str());
}
