# -*- coding: utf-8 -*-
class ConfiguracionsController < ApplicationController

  active_scaffold :"configuracion" do |conf|
    conf.label = "Configuración"

    conf.create.columns << :xbee_pan_id
    conf.update.columns << :xbee_pan_id

    conf.actions.exclude :create, :delete

    conf.list.columns = [:xbee_port, :xbee_pan_id, :xbee_channel, :xbee_mac, :xbee_key]

  end


end
