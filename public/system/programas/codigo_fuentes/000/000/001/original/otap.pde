#include <WaspXBeeDM.h>

// Step 2. Variables declaration
#define key_access "iEcolabK"

char* node_identifier = "0000000000000000\0";

uint8_t PANID[2] = {
  0x69,0x69};
uint8_t channel = 0x0F;

/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/

void setTime(char *cad){
  RTC.ON();
  
  // Setting time [yy:mm:dd:dow:hh:mm:ss]
  RTC.setTime(cad);
  delay(1000);
  
  USB.print(F("Time [YY:MM:DD:dw:hh:mm:ss]: "));
  USB.println(RTC.getTime());

}

void getNodeIdentifier(){
  
  // get own mac
  xbeeDM.getOwnMacLow();
  xbeeDM.getOwnMacHigh();  

  // change node_identifier string
  Utils.hex2str(xbeeDM.sourceMacHigh, node_identifier);
  Utils.hex2str(xbeeDM.sourceMacLow, &node_identifier[8]);

  node_identifier[16] = '\0';
    
}


/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/


void init_network_dm(){
  // Initialize XBee module
  xbeeDM.ON();
  delay(3000);

  //set parameters network
  xbeeDM.setChannel(channel);
  if( !xbeeDM.error_AT ) USB.println("Channel set OK");
  else USB.println("Error while changing channel");

  xbeeDM.setPAN(PANID);
  if( !xbeeDM.error_AT ) USB.println("PANID set OK");
  else USB.println("Error while changing PANID");  

  xbeeDM.setEncryptionMode(0); //0: disable
  if( !xbeeDM.error_AT ) USB.println("Security enabled");
  else USB.println("Error while enabling security");  

  // set node identifier in the network
  getNodeIdentifier();
  Utils.setID(node_identifier);
  xbeeDM.setNodeIdentifier(node_identifier);  
  if( !xbeeDM.error_AT ) USB.println("Node Identifier OK");
  else USB.println("Error while setting node identifier");  

  xbeeDM.writeValues();
  if( !xbeeDM.error_AT ) USB.println("Changes stored OK");
  else USB.println("Error while storing values");  

}

void check_for_otap(){
  // Check if new data is available
  if( xbeeDM.available() )
  {
    USB.println(F("Con actualizaciones ... "));
    xbeeDM.treatData();
    // Keep inside this loop while a new program is being received
    while( xbeeDM.programming_ON  && !xbeeDM.checkOtapTimeout() )
    {
      if( xbeeDM.available() )
      {
        xbeeDM.treatData();
      }
    } // fin while OTAP

  } // fin if de Datos disponibles

}

void setup() 
{

    // Write Authentication Key to EEPROM memory
  Utils.setAuthKey(key_access);

  USB.ON();
    
  init_network_dm();

  // CheckNewProgram is mandatory in every OTA program
  xbeeDM.checkNewProgram();   

}

void loop()
{
  
    USB.println("Check OTAP");
    
    check_for_otap();
  
  delay(1000);  

}

