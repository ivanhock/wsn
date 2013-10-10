#include <WaspXBeeDM.h>

// Step 2. Variables declaration
#define key_access "iEcolabK"

char* node_identifier = "0000000000000000\0";
char* wsn_coordinator = "0000000000000000\0";

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

void readWsnCoordinator(char *mac){  
    // write the 8bytes to EEPROM
 
  int position = 1024;
  for (int i = 0; i < 16; i++){
    mac[i] = Utils.readEEPROM(position++);    
  }

}

int readSleepTime(){  
  // write the 8bytes to EEPROM 
  int position = 1040;
  
  int minutos = Utils.readEEPROM(position);    
  
  // establecemos un rango optimo
  if ((minutos > 60) || (minutos < 0))
    minutos = 2;
  
  return minutos;
  
}

void setSleepTime(int time){  
    // write the 8bytes to EEPROM
 
  int position = 1040;
  
  Utils.writeEEPROM(position, time);    
  
}

void setWsnCoordinator(char *mac){  
  
  // write the 8bytes to EEPROM
  int position = 1024;
  for (int i = 0; i < 16; i++){
    Utils.writeEEPROM(position++, mac[i]);    
  }
  
  readWsnCoordinator(wsn_coordinator);
  
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

void check_for_configuration(){
  // Check if new data is available
  if( xbeeDM.available() )
  {
    USB.println("Con actualizaciones ... ");
    xbeeDM.treatData();
    
    if (!xbeeDM.error_RX){

      // Keep inside this loop while a new program is being received
      while( xbeeDM.programming_ON  && !xbeeDM.checkOtapTimeout() )
      {
        if( xbeeDM.available() )
        {
          xbeeDM.treatData();
        }
      } // fin while OTAP

      // check RX flag after 'treatData'
      // read available packets
      while(!xbeeDM.programming_ON && xbeeDM.pos>0 )
      {
          // Extract order and data to execute
          int order = xbeeDM.packet_finished[xbeeDM.pos-1]->data[0];
          char *data = (char *)calloc(xbeeDM.packet_finished[xbeeDM.pos-1]->data_length, sizeof(char));
          for(int i=0 ; i < (xbeeDM.packet_finished[xbeeDM.pos-1]->data_length - 1); i++)          
          { 
            data[i] = xbeeDM.packet_finished[xbeeDM.pos-1]->data[i+1];
          }
          data[xbeeDM.packet_finished[xbeeDM.pos-1]->data_length - 1] = '\0';
  
        switch (order){
          case 0x20: // set the clock
            USB.print(F("Set the clock to: "));
            USB.println(data);
            setTime(data);
            break;
          case 0x21:
            USB.print(F("Set the mac of coordinator: "));
            USB.println(data);
            setWsnCoordinator(data);
            break;
          case 0x22:
            int minutes;
            minutes = xbeeDM.packet_finished[xbeeDM.pos-1]->data[1];
            USB.print(F("Set the sleep time interval in minutes: "));
            USB.println(minutes);
            setSleepTime(minutes);
            break;
          default:
            USB.print("Order not specified: ");
            USB.println(order);
            break;
        }

        // Once a packet has been read it is necessary to 
        // free the allocated memory for this packet
        // free memory
        free(xbeeDM.packet_finished[xbeeDM.pos-1]); 

        //free pointer
        xbeeDM.packet_finished[xbeeDM.pos-1]=NULL; 

        //Decrement the received packet counter
        xbeeDM.pos--; 
      }

    } // Fin sin error en RX
    else{
      USB.print(F("Error en la recepcion"));
    }
  } // fin if de Datos disponibles

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
      USB.print(F("OTAP"));
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
    
  readWsnCoordinator(wsn_coordinator);
  USB.print("Mac coordinator: ");
  USB.println(wsn_coordinator);    

  USB.print("Sleep Time ");
  USB.print(readSleepTime());
  USB.println(" minute(s)");  
    
  init_network_dm();

  // CheckNewProgram is mandatory in every OTA program
//  xbeeDM.checkNewProgram();   

}

void loop()
{
  
    USB.println("Check OTAP and configurations");
    
    check_for_configuration();
  
    delay(5000);  

}

