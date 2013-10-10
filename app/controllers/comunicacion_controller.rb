class ComunicacionController < ApplicationController

  ##crontab
  ## java -classpath .:./lib/*:./bin es.iecolab.wsn.ReadData /dev/tty.usbserial-A6015JWE 38400 http://localhost:3000/api/new_data_mote 2>&1 >> output.log

  def index

    render :controller => :comunicacion, :action => :show_log

  end


  def log
    path = Rails.root.to_s+"/xbee/output.log"
    render(:text => "<pre>"+CGI::escapeHTML(`tail #{path} -n 10`)+"</pre>")
  end

  def show_log
  end


end
