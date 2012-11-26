class ChangeColumnPartDescription < ActiveRecord::Migration
  def up
  remove_column :part_descriptions, :below_300_wear_miles
  remove_column :part_descriptions, :above_300_wear_miles
  remove_column :part_descriptions, :lcv_wear_miles
  remove_column :part_descriptions, :off_road_wear_miles
  add_column :part_descriptions, :below_300_wear_miles, :string
  add_column :part_descriptions, :above_300_wear_miles, :string
  add_column :part_descriptions, :lcv_wear_miles, :string
  add_column :part_descriptions, :off_road_wear_miles, :string    
  end

  def down
  end
end
