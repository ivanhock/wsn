class CreateDatos < ActiveRecord::Migration
  def change
    create_table :datos do |t|
      t.integer :dispositivo_id
      t.timestamp :fecha
      t.decimal :valor, :precision => 10, :scale => 2
      t.integer :variable_id

      t.timestamps
    end
  end
end
