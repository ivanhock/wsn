class ApiController < ApplicationController

  def new_data_mote
    mac = params[:mac]
    data = params[:datos]

    mote = Dispositivo.find_by_mac(mac)

    datos = data.gsub(",", ".").split("#")
    #datos = data.split("#")

    if datos.length != 10
      render :text => "trama no completa" and return true
    end

    tiempo = Time.new(Date.today.year, Date.today.month, datos[3].to_i, datos[2].to_i, datos[1].to_i, datos[0].to_i)
    bateria_id = Variable.find_by_codigo("bateria")
    temp_aire_id = Variable.find_by_codigo("temp_aire")
    hume_aire_id = Variable.find_by_codigo("hume_aire")
    temp_suelo_id = Variable.find_by_codigo("temp_suelo")
    hume_suelo_id = Variable.find_by_codigo("hume_suelo")
    rssi_id = Variable.find_by_codigo("rssi")

    Dato.create(:dispositivo_id => mote.id, :variable_id => bateria_id.id, :valor => datos[4].to_i, :fecha => tiempo)
    Dato.create(:dispositivo_id => mote.id, :variable_id => temp_aire_id.id, :valor => datos[5].to_f, :fecha => tiempo)
    Dato.create(:dispositivo_id => mote.id, :variable_id => hume_aire_id.id, :valor => datos[6].to_f, :fecha => tiempo)
    Dato.create(:dispositivo_id => mote.id, :variable_id => temp_suelo_id.id, :valor => datos[7].to_f, :fecha => tiempo)
    Dato.create(:dispositivo_id => mote.id, :variable_id => hume_suelo_id.id, :valor => datos[8].to_f, :fecha => tiempo)
    Dato.create(:dispositivo_id => mote.id, :variable_id => rssi_id.id, :valor => datos[9].to_i, :fecha => tiempo)

    render :text => "OK" and return true

  end

end
