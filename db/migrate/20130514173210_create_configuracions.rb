class CreateConfiguracions < ActiveRecord::Migration
  def change
    create_table :configuracions do |t|
      t.string :xbee_port
      t.string :xbee_pan_id
      t.string :xbee_channel
      t.string :xbee_key
      t.string :xbee_mac

      t.timestamps
    end
  end
end
