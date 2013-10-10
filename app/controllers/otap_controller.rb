# -*- coding: utf-8 -*-
class OtapController < ApplicationController
  layout 'application'

  def index
    ## posibilidad de enviar un comando OTAP desde la WEB
    if request.post?
      c = Configuracion.last
      o = Otap.new
      o.write_conf(c.xbee_pan_id, c.xbee_channel, c.xbee_port, c.xbee_key)

      o.send_command(params[:texto])

      render :controller => :otap, :action => :show_log_otap
    end
  end



  def discover_devices
    c = Configuracion.last
    o = Otap.new
    o.write_conf(c.xbee_pan_id, c.xbee_channel, c.xbee_port, c.xbee_key)

    o.list_devices

    render :controller => :otap, :action => :show_log_otap

  end

  def send_start

    c = Configuracion.last
    o = Otap.new
    o.write_conf(c.xbee_pan_id, c.xbee_channel, c.xbee_port, c.xbee_key)

    mode = params[:mode]
    mac = params[:mac]
    p = Programa.find(params[:id])
    macs = (mac.join(",") if mac != nil) || ''

    comando = "-start_new_program --pid #{p.id.to_s.rjust(7, '0')} "
    if mode.upcase == "BROADCAST"
      comando = comando + " --mode BROADCAST"
    else
      comando = comando + " --mode UNICAST --mac #{macs}"
    end

    o.send_command(comando)

    render :controller => :otap, :action => :show_log_otap

  end

  def send_program

    c = Configuracion.last
    o = Otap.new
    o.write_conf(c.xbee_pan_id, c.xbee_channel, c.xbee_port, c.xbee_key)

    mode = params[:mode]
    mac = params[:mac]
    p = Programa.find(params[:id])
    macs = (mac.join(",") if mac != nil) || ''

    o.send_program(p.id.to_s.rjust(7, '0'), p.compilado.path, mode, macs)

    render :controller => :otap, :action => :show_log_otap

  end

  def log
    path = Rails.root.to_s+"/otap/output.log"
    render(:text => "<pre>"+CGI::escapeHTML(`tail #{path} -n 10`)+"</pre>")
  end

  def show_log_otap
  end


end
