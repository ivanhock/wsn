class Dispositivo < ActiveRecord::Base
  attr_accessible :descripcion, :identificador, :mac, :nombre, :software_ejecutando, :tipo, :ultima_comunicacion

  has_and_belongs_to_many :programas

  def to_s
    mac
  end
end
