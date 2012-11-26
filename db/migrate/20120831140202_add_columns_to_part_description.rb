class AddColumnsToPartDescription < ActiveRecord::Migration
  def change
  remove_column :part_descriptions, :above_300_wear
  remove_column :part_descriptions, :below_300_wear
  remove_column :part_descriptions, :lcv_wear
  remove_column :part_descriptions, :off_road_wear
  add_column :part_descriptions, :below_300_wear_miles, :integer
  add_column :part_descriptions, :below_300_wear_months, :string
  add_column :part_descriptions, :above_300_wear_miles, :integer
  add_column :part_descriptions, :above_300_wear_months, :string
  add_column :part_descriptions, :lcv_wear_miles, :integer
  add_column :part_descriptions, :lcv_wear_months, :string
  add_column :part_descriptions, :off_road_wear_miles, :integer
  add_column :part_descriptions, :off_road_wear_months, :string  
  end
end
