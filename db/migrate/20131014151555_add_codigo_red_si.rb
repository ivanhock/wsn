class AddCodigoRedSi < ActiveRecord::Migration
  def up
    add_column :configuracions, :codigo_wsn, :string
  end

  def down
    remove_column :configuracions, :codigo_wsn
  end

end
