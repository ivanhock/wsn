class CreateImagens < ActiveRecord::Migration
  def change
    create_table :imagens do |t|
      t.attachment :imagen_p
      t.attachment :imagen_1
      t.attachment :imagen_2
      t.text :descripcion

      t.timestamps
    end
  end
end
