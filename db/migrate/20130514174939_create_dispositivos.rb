class CreateDispositivos < ActiveRecord::Migration
  def change
    create_table :dispositivos do |t|
      t.string :mac
      t.string :identificador
      t.string :nombre
      t.text :descripcion
      t.timestamp :ultima_comunicacion
      t.string :tipo
      t.string :software_ejecutando

      t.timestamps
    end
  end
end
