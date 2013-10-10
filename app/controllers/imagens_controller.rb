# -*- coding: utf-8 -*-
class ImagensController < ApplicationController


  active_scaffold :"imagen" do |conf|

    conf.label = "Gestión de imágenes"

    conf.list.columns = [:imagen_p, :imagen_1, :imagen_2, :descripcion]

    columns[:imagen_p].label = "Resultado"
    columns[:imagen_1].label = "Imagen 1"
    columns[:imagen_2].label = "Imagen 2"


    conf.action_links.add 'Comprobar', :action => :analizar, :type => :member

    conf.action_links.add 'Capturar', :action => :capturar, :type => :collection

  end

  def capturar

    im = Imagen.capturar()
    im.save
    im.analizar
    im.save

    render :text => "Operación concluida con éxito" and return true

  end

  def analizar

    id = params[:id]
    record = Imagen.find(id)
    record.analizar
    record.save

    render :text => "Operación concluida con éxito" and return true

  end

end
