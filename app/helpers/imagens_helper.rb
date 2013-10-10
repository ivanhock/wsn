module ImagensHelper

  def descripcion_column(record, input_name = nil)

   sanitize(record.descripcion)

  end

end