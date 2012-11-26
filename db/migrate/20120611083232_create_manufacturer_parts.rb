class CreateManufacturerParts < ActiveRecord::Migration
  def change
    create_table :manufacturer_parts do |t|
      t.references  :manufacturer, :null => false
      t.references  :part, :null => false
      t.float :price
      t.timestamps
    end
  end
end
