class CreateProgramas < ActiveRecord::Migration
  def change
    create_table :programas do |t|
      t.string :nombre
      t.string :tipo
      t.text :descripcion
      t.attachment :codigo_fuente
      t.attachment :compilado

      t.timestamps
    end
  end
end
