class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.text :name, :null => false

      t.timestamps
    end
  end
end
