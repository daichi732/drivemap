class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name, limit: 20, null: false
      t.text :description

      t.timestamps
    end
  end
end
