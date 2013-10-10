class Variable < ActiveRecord::Base
  attr_accessible :codigo, :descripcion, :nombre

  def to_s
    nombre.to_s
  end

end
