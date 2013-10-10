# -*- coding: utf-8 -*-
require 'RMagick'

class Imagen < ActiveRecord::Base
  attr_accessible :descripcion, :imagen_1, :imagen_2, :imagen_p

  has_attached_file :imagen_1, :styles => { :thumbnail => "150x150>" }
  has_attached_file :imagen_2, :styles => { :thumbnail => "150x150>" }
  has_attached_file :imagen_p, :styles => { :thumbnail => "150x150>" }

#  after_create :analizar
#  after_save :analizar

#  def to_s
#    self.id.to_s
#  end

  def self.capturar
    mi_path = Rails.root.to_s+"/tmp/system.log"
    ## get video ports
    system("ls -l /dev/video* | awk '{print $10}' 2>&1 >#{mi_path}")
    aux = File.open(mi_path).read
    puertos = aux.split("\n")

    ## capture image in temporal files
    path = Rails.root.to_s+"/tmp/"
    system("rm #{path}salida_*.jpg")

    ## TODO: eliminar
    puertos = ["Logitech Camera", "Logitech Camera"]
    i = 1
    for puerto in puertos
      ## TODO: cambiar para la raspberry
      ## system("uvccapture -d#{puerto} -x800 -y600 -o#{path}salida_#{i}.jpg &")
      ##system("imagesnap -d '#{puerto}' #{path}salida_#{i}.jpg &")
      fork{"imagesnap -d '#{puerto}' #{path}salida_#{i}.jpg &"}
      i = i + 1
    end

    ## esperamos a que las capturas han terminado
    #pid = `ps ux | awk '/imagesnap/ && !/awk/ {print $2}'`.split("\n")
    Process.waitall

    ## generate Imagen activerecord
    im = Imagen.new
#    path_no_image = Rails.root.to_s+"/public/ndvi_example.jpg"
#    for i in 1..2
#      path_img = (path+"salida_#{i}.jpg" if File.exist?(path+"salida_#{i}.jpg")) || path_no_image
#      f = File.open(path_img)
#      im.send("imagen_#{i}", f)
#    end

    if File.exist?(path+"salida_1.jpg")
      path_img = path+"salida_1.jpg"
    else
      path_img = Rails.root.to_s+"/public/ndvi_example.jpg"
    end
    f1 = File.open(path_img)

    if File.exist?(path+"salida_2.jpg")
      path_img = path+"salida_2.jpg"
    else
      path_img = Rails.root.to_s+"/public/ndvi_example.jpg"
    end
    f2 = File.open(path_img)
    im.imagen_1 = f1
    im.imagen_2 = f2

    return im

  end

  def analizar
    mi_path = Rails.root.to_s+"/tmp/system.log"

    ## chequeamos la diferencia entre la imagen_1 y la imagen_2
    i_1 = Magick::Image.read(imagen_1.path)[0]
    i_2 = Magick::Image.read(imagen_2.path)[0]

    diferencia = ((i_1 <=> i_2) == 0)? "No": "Si"
    system("compare -metric PSNR #{imagen_1.path} #{imagen_2.path} #{Rails.root.to_s}/tmp/test.jpg 2> #{mi_path}")
    cantidad_diferencia = `cat #{mi_path}`.strip!

    ## calculamos la imagen_p según fórmula NDVI
    # NDVI = (nearInfrared - Red) / (nearInfrared + Red)
    nir = i_1.dispatch(0,0,i_1.columns, i_1.rows, "R")
    rojo = i_2.dispatch(0,0,i_2.columns, i_2.rows, "R")


    ## matrix operation
    ndvi = Array.new(nir.length, 0)
    total = nir.length - 1
    for i in 0..total
        suma = nir[i] + rojo[i]
        ndvi[i] = ((nir[i] - rojo[i]) / (suma * 1.0)) if suma != 0
        ndvi[i] = (0.5)*ndvi[i] + 0.5 ## reescalado 0 - 1
    end

    ## construimos la imagen
    image = Magick::Image.constitute(i_1.columns, i_1.rows, "I", ndvi)
    path_r = Rails.root.to_s+"/tmp/ndvi.jpg"
    image.write(path_r)
    f = File.open(path_r)
    self.imagen_p = f

    ## obtenemos estadísticos de la imagen
    self.descripcion = "Escala: 0 (nula actividad) - 1 (+actividad) <br/>Diferencia: #{diferencia} (#{cantidad_diferencia})<br/>Media: #{ndvi.mean}<br/>Mediana: #{ndvi.median}<br/>Mínimo: #{ndvi.min}<br/>Máximo: #{ndvi.max}<br/>Percentiles 25, 75: #{ndvi.percentile(25)}, #{ndvi.percentile(75)}"
    self.save!

  end


end
