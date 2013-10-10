class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :codigo
      t.string :nombre
      t.text :descripcion

      t.timestamps
    end
  end
end
