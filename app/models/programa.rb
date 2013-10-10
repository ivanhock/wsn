# -*- coding: utf-8 -*-
class Programa < ActiveRecord::Base
  attr_accessible :codigo, :codigo_fuente, :compilado, :nombre, :tipo, :descripcion

  has_attached_file :codigo_fuente
  has_attached_file :compilado

  before_save :actualizar_codigo
  before_create :actualizar_codigo

  has_and_belongs_to_many :dispositivos

  def to_s
    nombre.to_s
  end

  def actualizar_codigo
    self.codigo = nombre[0..6].ljust(7, '0')
  end

end
