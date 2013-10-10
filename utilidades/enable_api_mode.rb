require '../config/environment.rb'

require 'rubygems'
require 'ruby_xbee'

@conf = Configuracion.last
baud = 38400
data_bits = 8
stop_bits = 1
parity = 0

@conf_xbee = XBee::Config::XBeeUARTConfig.new(baud)
@xbee_api = XBee::BaseAPIModeInterface.new(@conf.xbee_port, @conf_xbee)

## sent a data frame to set clock in waspmotes
frame_type = 1 ## set clock
time = Time.now
## Setting time [yy:mm:dd:dow:hh:mm:ss]
message = "###{frame_type}##{time.strftime("%y:%m:%d:%u:%H:%M:%S")}"




# read XBee output forever
while( 1 )
  response = @xbee_api.getresponse(true)

  ## procesamos la respuesta

end


