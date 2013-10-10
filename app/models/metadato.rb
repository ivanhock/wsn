class Metadato < ActiveRecord::Base
  attr_accessible :battery, :dispositivo, :rssi

  belongs_to :dispositivo

  def to_s
    dispositivo.to_s
  end

end
