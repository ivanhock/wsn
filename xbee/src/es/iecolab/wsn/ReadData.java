package es.iecolab.wsn;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import org.apache.http.HttpEntity;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.NameValuePair;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import java.util.ArrayList;
import java.util.List;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.StringBody;

import com.rapplogic.xbee.api.ApiId;
import com.rapplogic.xbee.api.AtCommand;
import com.rapplogic.xbee.api.AtCommandResponse;
import com.rapplogic.xbee.api.XBee;
import com.rapplogic.xbee.api.XBeeException;
import com.rapplogic.xbee.api.XBeeResponse;
import com.rapplogic.xbee.api.zigbee.ZNetRxResponse;
import com.rapplogic.xbee.util.ByteUtils;

public class ReadData {

	private final static Logger log = Logger.getLogger(ReadData.class);
	private static XBee xbee = new XBee();
	
	public void setAPMode(int value) {
		try {
			log.info("Attempting to set AP to " + value);
			AtCommandResponse ap = xbee
					.sendAtCommand(new AtCommand("AP", value));
			if (ap.isOk()) {
				log.info("Successfully set AP mode to " + value);
			} else {
				throw new XBeeException("Attempt to set AP=2 failed");
			}
		} catch (XBeeException ex) {
			log.error(ex.getMessage());
		}
	}
	

		
		private void PostData(String url, String mac, String texto) throws ClientProtocolException, IOException{
							
			HttpClient httpclient = new DefaultHttpClient();
			HttpPost httppost = new HttpPost(url);
			MultipartEntity form = new MultipartEntity();
			byte[] test = {0x55, 0x23, 0x33};
			form.addPart("mac", new StringBody(mac));
			form.addPart("datos", new StringBody(texto));
			//form.addPart("datos", new IntArrayBody(data, null));
			
			httppost.setEntity(form);

			//Execute and get the response.
			HttpResponse response = httpclient.execute(httppost);
			HttpEntity entity = response.getEntity();

			if (entity != null) {
			    InputStream instream = entity.getContent();
			    try {
			        // do something useful
			    } finally {
			        instream.close();
			    }
			}	        
		}
	
	private String convertirDatos(int[] data){
		
		String resultado = "";
		
		if (data.length != 16){
			return resultado;
		}
		
		//tiempo
		int segundos = data[0] >> 2;
		int minutos = (((data[0] << 6) & 0xFF) >> 2)| ((data[1] >> 4) & 0xFF);
		int hora = (((data[1] << 4) & 0xFF) >> 3) | ((data[2] >> 7) & 0xff);
		int dia = ((data[2] << 1) & 0xFF) >> 3;
		int bateria = data[3];
		short temp_aire = getShort(data[4], data[5]);
		short hume_aire = getShort(data[6], data[7]);
		short temp_suelo = getShort(data[8], data[9]);
		short hume_suelo = getShort(data[10], data[11]);		
		
		resultado = String.format("%d#%d#%d#%d#%d#%.2f#%.2f#%.2f#%.2f", segundos, minutos, hora, dia, bateria, temp_aire/100.0, hume_aire/100.0,temp_suelo/100.0,hume_suelo/100.0);
		
		return resultado;
		
	}
		
    private short getShort(int argB1, int argB2){
        return (short)((argB1 & 0xff) | (argB2 << 8));
    }
    
	private ReadData(String port, int baud, String url) throws Exception {
		//XBee xbee = new XBee();		

		try {			
			// replace with the com port of your receiving XBee (typically your end device)
//			xbee.open("/dev/tty.usbserial-A6005uRz", 9600);
			xbee.open(port, baud);

			setAPMode(2);
			
			//set options of network
			if (xbee.sendAtCommand(new AtCommand("JN", 0x01)).isOk())
				log.info("Set join Notification");
			String node_identifier = "0013A200408BC826\0";
			if (xbee.sendAtCommand(new AtCommand("CH", 0x0F)).isOk())
				log.info("Set CH");
			int[] pan = {0x69, 0x69};			
			if (xbee.sendAtCommand(new AtCommand("ID", pan)).isOk())
				log.info("Set PAN_ID");			
			if (xbee.sendAtCommand(new AtCommand("NI", ByteUtils.stringToIntArray(node_identifier))).isOk())
					log.info("Set Node Identifier: "+node_identifier);			
			
			while (true) {

				try {
					// we wait here until a packet is received.
					XBeeResponse response = xbee.getResponse();
					
					log.info("received response " + response.toString());
					
					if (response.getApiId() == ApiId.ZNET_RX_RESPONSE) {
						// we received a packet from ZNetSenderTest.java
						ZNetRxResponse rx = (ZNetRxResponse) response;
						
						log.info("Received RX packet, option is " + rx.getOption() + ", sender 64 address is " + ByteUtils.toBase16(rx.getRemoteAddress64().getAddress()) + ", remote 16-bit address is " + ByteUtils.toBase16(rx.getRemoteAddress16().getAddress()) + ", data is " + ByteUtils.toBase16(rx.getData()));
						
						String mac = ByteUtils.toBase16(rx.getRemoteAddress64().getAddress(), "").replaceAll("0x", "");
						log.info(mac);
						// convertimos el int[] en string con los datos que necesitamos
						// dia,hora,minuto,segundo,bateria,temp_aire,hume_aire,temp_suelo,hume_suelo,secuencia
						String resultado = convertirDatos(rx.getData());
												
						// optionally we may want to get the signal strength (RSSI) of the last hop.
						// keep in mind if you have routers in your network, this will be the signal of the last hop.
						AtCommand at = new AtCommand("DB");
						xbee.sendAsynchronous(at);
						XBeeResponse atResponse = xbee.getResponse();
						
						int rssi = 0; 
						if (atResponse.getApiId() == ApiId.AT_RESPONSE) {
							rssi = -((AtCommandResponse)atResponse).getValue()[0];
							// remember rssi is a negative db value
							log.info("RSSI of last response is " + rssi);
						} else {
							// we didn't get an AT response
							log.info("expected RSSI, but received " + atResponse.toString());
						}
													
						// Enviamos los datos recibidos al wsn
						PostData(url, mac, resultado+"#"+rssi);

					} else {
						log.debug("received unexpected packet " + response.toString());
					}
				} catch (Exception e) {
					log.error(e);
				}
			}
			
		} finally {
			if (xbee.isConnected()) {
				xbee.close();
			}
		}
	}

	public static void main(String[] args) throws Exception {
		
		String port = args[0]; //"/dev/tty.usbserial-A6015JWE";
		int baud = Integer.parseInt(args[1]); //38400;
		String url = args[2];
		
		// init log4j
		PropertyConfigurator.configure("log4j.properties");
		new ReadData(port, baud, url);
		
	}
	
}
