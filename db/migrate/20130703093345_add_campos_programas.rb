class AddCamposProgramas < ActiveRecord::Migration
  def up
    add_column :programas, :codigo, :string
  end

  def down
    remove_column :programas, :codigo
  end

end
