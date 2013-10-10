class Dato < ActiveRecord::Base
  attr_accessible :dispotivo, :fecha, :valor, :variable, :dispositivo_id, :variable_id

  belongs_to :dispositivo
  belongs_to :variable

end
