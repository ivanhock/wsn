class ConfiguracionColumnas < ActiveRecord::Migration
  def up
    add_column :configuracions, :url_sistema_informacion, :string
    add_column :configuracions, :lat, :string
    add_column :configuracions, :lng, :string
    add_column :configuracions, :api_key, :string
  end

  def down
    remove_column :configuracions, :url_sistema_informacion
    remove_column :configuracions, :lat
    remove_column :configuracions, :lng
    remove_column :configuracions, :api_key
  end

end
