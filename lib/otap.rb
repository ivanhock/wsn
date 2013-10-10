# -*- coding: utf-8 -*-
class Otap

  attr_accessor :path, :bin, :outputs

  def initialize
    @path = Rails.root.to_s+"/otap"
    @bin = @path + "/otap"
    @output = @path + "/output.log"
  end

  def send_command(texto)

    Dir.chdir(@path)
    mi_path = @output
    system("rm #{mi_path}")
    system("echo '#{Time.now} - Iniciando el envío del comando ... ' > #{mi_path}")

    system("bash #{bin} #{texto} 2>&1 >>#{mi_path}")

    system("echo '#{Time.now} - Finalizado el envío del comando ... ' >> #{mi_path}")

  end
  handle_asynchronously :send_command

  def send_program(pid, path_p, mode = 'BROADCAST', macs = nil)

    Dir.chdir(@path)
    mi_path = @output
    system("rm #{mi_path}")
    system("echo '#{Time.now} - Iniciando el envío del programa ... ' > #{mi_path}")

    base = "bash #{bin} -send --file #{path_p} --deliveries 5 --pid #{pid}"

    #system("echo '#{base}' >>#{mi_path}")

    if mode.upcase == 'BROADCAST'
      system("#{base} --mode BROADCAST 2>&1 >>#{mi_path}")
    else
      #system("echo '#{base} --mode UNICAST --mac #{macs}' >> #{mi_path}")
      system("#{base} --mode UNICAST --mac #{macs} 2>&1 >>#{mi_path}")
    end

    system("echo '#{Time.now} - Finalizado el envío del programa ... ' >> #{mi_path}")

  end
  handle_asynchronously :send_program


  def list_devices
    Dir.chdir(@path)
    mi_path = @output #"#{@output}/list_devices.txt"
    system("rm #{mi_path}")
    system("echo '#{Time.now} - Iniciando la búsqueda de dispositivos ... ' > #{mi_path}")
    system("bash #{bin} -scan_nodes --mode BROADCAST 2>&1 >>#{mi_path}")
    system("echo '#{Time.now} - Finalizada la búsqueda de dispositivos, procesando salida ... ' >> #{mi_path}")

    texto = `cat #{mi_path}`

    lineas = texto.split("\n")
    inicio = lineas.index { |x| x.include?("Total") }
    salida = []

    total_devices = lineas[inicio].match(".*Nodes:\ (.*)\ -")[1].to_i
    for i in 1..total_devices
      linea = lineas[inicio + i]

      mac = linea.match("[a-z0-9]{16}")[0]
      nombre = (linea.match("Node .* - ([A-Za-z0-9]{16}) -")[1] if linea.match("Node .* - ([A-Za-z0-9]{16}) -") != nil) || ''
      software = (linea.match("Node .* - [A-Za-z0-9]{16} - (.*) -")[1] if linea.match("Node .* - [A-Za-z0-9]{16} - (.*) -") != nil) || ''
      estado = (linea.match(".* - .* - .* - (.*)$")[1] if linea.match(".* - .* - .* - (.*)$") != nil) || ''

      ## buscamos el dispositivo:
      disp = Dispositivo.find_by_mac(mac)
      if disp
        disp.software_ejecutando = software
        disp.ultima_comunicacion = Time.now
        disp.save
        salida << "Se ha actualizado el dispositivo con mac #{mac}"
      else
        disp = Dispositivo.create(:mac => mac, :nombre => nombre, :software_ejecutando => software, :ultima_comunicacion => Time.new)
        salida << "Se ha creado el dispositivo con mac #{mac}"
      end

    end

    f = File.open(mi_path, "a+")
    f.puts(salida.join(13.chr))
    f.close

    return true

  end

  handle_asynchronously :list_devices

  def write_conf(pan_id, channel, port, key)

    f = File.open("#{@path}/xbee.conf.new", "r")
    conf = ""
    while (line = f.gets)
      conf += line
    end
    f.close

    ##remplazamos
    conf.gsub!("$PANID$", pan_id)
    conf.gsub!("$KEY$", key)
    conf.gsub!("$PORT$", port)
    conf.gsub!("$CHANNEL$", channel)

    f_c = File.open("#{@path}/xbee.conf", "w")
    f_c.write(conf)
    f_c.close

  end


end