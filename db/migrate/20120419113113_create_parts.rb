class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.text :part_number, :null => false
      t.integer :description, :null => false
      t.float :labour_time
      t.integer :interval_miles, :null => false
      t.text :interval_months, :null => false
      t.integer :ll_interval_miles
      t.text :ll_interval_months
      t.decimal :price, :precision => 8, :scale => 2, :null => false
      t.string :part_type, :null => false, :limit => 1 # W = Wear, S = Service
      t.datetime :live_datetime, :null => false
      t.timestamps
    end
  end
end
