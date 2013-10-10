class VariablesController < ApplicationController

  active_scaffold :"variable" do |conf|

    conf.list.columns = [:codigo, :nombre, :descripcion]

    conf.create.columns = [:codigo, :nombre, :descripcion]
    conf.update.columns = [:codigo, :nombre, :descripcion]

  end

end
