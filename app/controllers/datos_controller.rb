class DatosController < ApplicationController

  active_scaffold :"dato" do |conf|

    conf.list.columns = [:dispositivo, :fecha, :variable, :valor]

    columns[:dispositivo].form_ui = :select
    columns[:variable].form_ui = :select

    conf.actions.add :export

    conf.list.sorting = {:fecha => :desc}

  end

end
