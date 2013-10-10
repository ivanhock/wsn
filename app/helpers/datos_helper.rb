module DatosHelper

  def fecha_column(record, input = nil)
    I18n.l(record.fecha, :format => "%Y-%m-%d, %H:%M:%S")
  end

end
