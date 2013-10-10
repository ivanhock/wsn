# -*- coding: utf-8 -*-
class ProgramasController < ApplicationController

  active_scaffold :"programa" do |conf|

    conf.list.columns = [:codigo, :nombre, :tipo]

    conf.action_links.add 'Enviar', :action => :enviar, :type => :member
    conf.action_links.add 'Iniciar', :action => :iniciar, :type => :member

    conf.create.columns = [:nombre, :tipo, :descripcion, :codigo_fuente, :compilado]
    conf.update.columns = [:nombre, :tipo, :descripcion, :codigo_fuente, :compilado]

  end

  def enviar

    @record = Programa.find(params[:id])

    if request.post?
      redirect_to :controller => :otap, :action => :send_program, :params => params and return true
    end

    render :layout => false

  end

  def iniciar

    @record = Programa.find(params[:id])

    if request.post?
      redirect_to :controller => :otap, :action => :send_start, :params => params and return true
    end

    render :layout => false

  end

end
