class CreateTransmisions < ActiveRecord::Migration
  def change
    create_table :transmisions do |t|
      t.date :desde_fecha
      t.date :hasta_fecha
      t.timestamp :fecha
      t.string :origen

      t.timestamps
    end
  end
end
