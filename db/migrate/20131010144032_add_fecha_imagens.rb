class AddFechaImagens < ActiveRecord::Migration
  def up
    add_column :imagens, :fecha, :timestamp
    add_column :imagens, :lat, :string
    add_column :imagens, :lng, :string
  end

  def down
    remove_column :imagens, :fecha
    remove_column :imagens, :lat
    remove_column :imagens, :lng
  end

end
