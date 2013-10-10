class AddFechaImagens < ActiveRecord::Migration
  def up
    add_column :imagens, :fecha, :timestamp
  end

  def down
    remove_column :imagens, :fecha
  end

end
