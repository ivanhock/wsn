class CreateMetadatos < ActiveRecord::Migration
  def change
    create_table :metadatos do |t|
      t.integer :dispositivo_id
      t.integer :rssi
      t.integer :battery

      t.timestamps
    end
  end
end
