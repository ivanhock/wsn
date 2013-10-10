package es.iecolab.wsn;

import java.io.IOException;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

import com.rapplogic.xbee.api.ApiId;
import com.rapplogic.xbee.api.AtCommand;
import com.rapplogic.xbee.api.AtCommandResponse;
import com.rapplogic.xbee.api.PacketListener;
import com.rapplogic.xbee.api.XBee;
import com.rapplogic.xbee.api.XBeeAddress64;
import com.rapplogic.xbee.api.XBeeConfiguration;
import com.rapplogic.xbee.api.XBeeException;
import com.rapplogic.xbee.api.XBeeResponse;
import com.rapplogic.xbee.api.XBeeTimeoutException;
import com.rapplogic.xbee.api.zigbee.ZNetRxResponse;
import com.rapplogic.xbee.api.zigbee.ZNetTxRequest;
import com.rapplogic.xbee.api.zigbee.ZNetTxStatusResponse;
import com.rapplogic.xbee.util.ByteUtils;

public class SetWsnOptions {

	private final static Logger log = Logger.getLogger(SetWsnOptions.class);

	private static XBee xbee = new XBee();

	public int sendBroadcastMsg(int [] payload){
		
		int output = 0;
		ZNetTxRequest request = new ZNetTxRequest(XBeeAddress64.BROADCAST, payload);
		// make it a broadcast packet
		request.setOption(ZNetTxRequest.Option.BROADCAST);

		
		try {
			
			xbee.sendAsynchronous(request);
			output = 1;
			
			try {
				// wait a bit then send another packet
				Thread.sleep(1000);
			} catch (InterruptedException e) {
			}

			log.info("Successfully sent");
			
		} catch (XBeeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			log.error(e.getMessage());
			output = -1;
		}

		return output;
		
	}
	
	public int sendUnicastMsg(int[] mac_destination, int[] payload) {
		int output = 0;

		try {

			// 0013a200408bc824
			XBeeAddress64 addr64 = new XBeeAddress64(mac_destination);
			ZNetTxRequest request = new ZNetTxRequest(addr64, payload);

			try {
				
				//search the node to send unicast msg
	
//				if (xbee.sendAtCommand(new ATCommand("", mac_destination)).isOk())
//					log.info("Buscando al nodo");
								
				ZNetTxStatusResponse response = (ZNetTxStatusResponse) xbee
						.sendSynchronous(request, 10000);
								
				// update frame id for next request
				request.setFrameId(xbee.getNextFrameId());

				if (response.getDeliveryStatus() == ZNetTxStatusResponse.DeliveryStatus.SUCCESS) {
					log.info("Successful sent message");
					output = 1;
				} else {

					// packet failed. log error
					// it's easy to create this error by unplugging/powering off
					// your remote xbee. when doing so I get: packet failed due
					// to error: ADDRESS_NOT_FOUND
					log.error("packet failed due to error: "
							+ response.getDeliveryStatus());
					
					output = -1;

				}

				xbee.clearResponseQueue();
				
				// I get the following message: Response in 75, Delivery status
				// is SUCCESS, 16-bit address is 0x08 0xe5, retry count is 0,
				// discovery status is SUCCESS
				log.info("Delivery status is "
						+ response.getDeliveryStatus()
						+ ", retry count is "
						+ response.getRetryCount() + ", discovery status is "
						+ response.getDeliveryStatus());
			} catch (XBeeTimeoutException e) {
				log.warn("request timed out");
			}

		} catch (XBeeException ex) {
			log.error(ex.getMessage());
			output = -1;
		}

		return output;

	}

	public void closeXbee() {
		xbee.close();
	}

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

	public SetWsnOptions(String port, int baud) throws XBeeException,InterruptedException, NoSuchPortException, PortInUseException, IOException {	
		
		try {
						
			xbee = new XBee(new XBeeConfiguration().withMaxQueueSize(100).withStartupChecks(false));
			xbee.open(port, baud);
			
			try {
				// wait a bit then send another packet
				Thread.sleep(2000);
			} catch (InterruptedException e) {
			}
			
			/*
			AtCommandResponse ap = (AtCommandResponse) xbee.sendSynchronous(new AtCommand("FR"), 1000);
						if (ap.isOk()) {
				log.info("Successfully set Reset.");	
			} else {
				throw new XBeeException("Attempt to set AP=2 failed");
			}

						try {
							// wait a bit then send another packet
							Thread.sleep(2000);
						} catch (InterruptedException e) {
						}
			 
			 */
			
			this.setAPMode(2);

			xbee.close();

			try {
				// wait a bit then send another packet
				Thread.sleep(2000);
			} catch (InterruptedException e) {
			}

			xbee = new XBee();
			// replace with port and baud rate of your XBee
			xbee.open(port, baud);														

			//set options of network
			if (xbee.sendAtCommand(new AtCommand("JN", 0x01)).isOk())
				log.info("Set join Notification");
			String node_identifier = "0013A200408BC826";
			if (xbee.sendAtCommand(new AtCommand("CH", 0x0F)).isOk())
				log.info("Set CH");
			int[] pan = {0x69, 0x69};			
			if (xbee.sendAtCommand(new AtCommand("ID", pan)).isOk())
				log.info("Set PAN_ID");			
			if (xbee.sendAtCommand(new AtCommand("NI", ByteUtils.stringToIntArray(node_identifier))).isOk())
					log.info("Set Node Identifier: "+node_identifier);			
			
			try {
				// wait a bit then send another packet
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				log.error(e.getMessage());
			
			}
		}catch(Exception ex){
			log.error(ex.getMessage());
		}			
						
	}

	/*
	private static int[] payloadSetWsnConfigFile(String[] options){
		String s = "PANID=6969\nCHANNEL=0x0F\n";
		int[] msg = ByteUtils.stringToIntArray(s);
		int[] payload = new int[1 + msg.length];
		payload[0] = 0x22;
		System.arraycopy(msg, 0, payload, 1, msg.length);		
		return payload;
	}

	private static int[] payloadSetMoteId(String name){
		int[] msg = ByteUtils.stringToIntArray(name);
		int[] payload = new int[1 + msg.length];
		payload[0] = 0x21;
		System.arraycopy(msg, 0, payload, 1, msg.length);		
		return payload;
	}

	 */
	
	private static int[] payloadSetWsnCoordinator(String mac){		
		int[] msg = ByteUtils.stringToIntArray(mac.toUpperCase());
		int[] payload = new int[1 + msg.length];
		payload[0] = 0x21;
		System.arraycopy(msg, 0, payload, 1, msg.length);		
		return payload;
	}

	private static int[] payloadSetTimerSleep(int minutes){		
		int[] payload = new int[2];
		payload[0] = 0x22;
		payload[1] = minutes;
		return payload;
	}

	private static int[] payloadSetClock(){
		// yy:mm:dd:dow:hh:mm:ss
		Format formatter = new SimpleDateFormat("yy:MM:dd::HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		Date hoy = new Date();
		calendar.setTime(hoy);
		String s = formatter.format(hoy);
		s = s.replaceFirst("::", ":0" + calendar.get(Calendar.DAY_OF_WEEK)
				+ ":");
		log.info("Fecha: " + s);
		int[] msg = ByteUtils.stringToIntArray(s);
		int[] payload = new int[1 + msg.length];
		payload[0] = 0x20;
		System.arraycopy(msg, 0, payload, 1, msg.length);
		
		return payload;
	}
	
	private static int[] payloadRequestStatusMote(){
		int[] payload = new int[1];
		payload[0] = 0x24;
		return payload;
	}
	
	public static void main(String[] args) throws XBeeException,
			InterruptedException, NoSuchPortException, PortInUseException,
			IOException {
		
		PropertyConfigurator.configure("log4j.properties");
		
		if (args.length < 4){
			log.error("execute: java SetTime.class serial_port baud_rate type_operation type_msg mac_destination options");
			log.error("type_operation: 20 - Set Clock");
			log.error("				   21 - Set mote id");
			log.error("				   22 - Set sleep time in minutes");
			log.error("type_msg: UNICAST | BROADCAST");
			log.error("mac_destination: 0013a200408bc824 (optional, only required for UNICAST type_msg");
			log.error("options: differents parameters for type_operation set");
			return;
		}
		
		String port = args[0]; //"/dev/tty.usbserial-A6015JWE";
		int baud = Integer.parseInt(args[1]); //38400;
		int type_operation = Integer.parseInt(args[2]);
		String type_msg = args[3].toUpperCase(); //"UNICAST";
		String mac_destination = "";		
		int option = 4;
		if (args.length > 4 && type_msg.equals("UNICAST")){
			mac_destination = args[option]; //= "0013a200408bc824";
			option++;
		}
		String[] options = Arrays.copyOfRange(args, option, args.length);

		int[] payload = null;
		boolean wait_response = false;
		int read_timeout = 10000; // 10s in milliseconds
		
		switch(type_operation){
			case 20:
				payload = payloadSetClock();
				break;
			case 21:
				payload = payloadSetWsnCoordinator(options[0]);
				break;
			case 22:
				payload = payloadSetTimerSleep(Integer.parseInt(options[0]));
				break;
			default:
				log.info("Not code for type_operation");
				break;
		}
			
		//Open XBEE in APMode 2
		SetWsnOptions settime = new SetWsnOptions(port, baud);

		if (type_msg.equals("UNICAST") && !mac_destination.equals("")){
			int[] address = new int[8];
			int i = 0;
			for (int x=0; x < mac_destination.length(); x += 2){
				address[i++] = Integer.parseInt(mac_destination.substring(x, x + 2), 16);
			}
			settime.sendUnicastMsg(address, payload);
			
		} else{
			settime.sendBroadcastMsg(payload);
		}
		
		if (wait_response){ 
			try{
				long start = System.currentTimeMillis();
				while (System.currentTimeMillis() < (start + read_timeout)){
					XBeeResponse response = xbee.getResponse(read_timeout);
					if (response.getApiId() == ApiId.ZNET_RX_RESPONSE) {
						// we received a packet from ZNetSenderTest.java
						ZNetRxResponse rx = (ZNetRxResponse) response;
					String data = ByteUtils.toString(rx.getData()); //ByteUtils.toBase16(rx.toString());
					log.info("received response " + data);			
					}
				}				
			}catch(XBeeTimeoutException ex){				
			}			
		}
		
		//Close XBEE in APMode 1 (to enable OTAP process)
		settime.setAPMode(1);
		settime.closeXbee();
		
	}

}
