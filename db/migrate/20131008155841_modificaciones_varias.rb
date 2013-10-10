class ModificacionesVarias < ActiveRecord::Migration

  def change

    create_table :dispositivos_programas, :id => false do |t|
      t.integer :dispositivo_id
      t.integer :programa_id
    end

  end

end
