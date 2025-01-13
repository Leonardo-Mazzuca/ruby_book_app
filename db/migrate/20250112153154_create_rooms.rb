class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.string :availability
      t.string :address
      t.decimal :price
      t.string :image

      t.timestamps
    end
  end
end
