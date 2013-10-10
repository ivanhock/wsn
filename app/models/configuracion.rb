class Configuracion < ActiveRecord::Base
  attr_accessible :xbee_channel, :xbee_key, :xbee_pan_id, :xbee_port
end
