# -*- coding: utf-8 -*-
class DispositivosController < ApplicationController

  active_scaffold :"dispositivo" do |conf|

    conf.list.columns = [:identificador, :mac, :nombre, :tipo, :ultima_comunicacion, :software_ejecutando]

    conf.action_links.add 'Dispositivos activos', :action => :discover_devices, :controller => :otap, :page => true

    columns[:programas].form_ui = :select

  end


end
