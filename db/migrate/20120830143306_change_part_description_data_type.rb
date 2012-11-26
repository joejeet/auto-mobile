class ChangePartDescriptionDataType < ActiveRecord::Migration
  def up
  remove_column :part_descriptions, :above_300_wear
  remove_column :part_descriptions, :below_300_wear
  remove_column :part_descriptions, :lcv_wear
  remove_column :part_descriptions, :off_road_wear
  remove_column :part_descriptions, :spread_miles
  remove_column :part_descriptions, :spread_months
  remove_column :part_descriptions, :description
  add_column :part_descriptions, :above_300_wear, :string
  add_column :part_descriptions, :below_300_wear, :string
  add_column :part_descriptions, :lcv_wear, :string
  add_column :part_descriptions, :off_road_wear, :string
  add_column :part_descriptions, :description, :string
  end

  def down
  end
end
