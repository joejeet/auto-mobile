class AddColumnsForWearParts < ActiveRecord::Migration
  def up
  add_column :part_descriptions, :above_300_wear, :text
  add_column :part_descriptions, :below_300_wear, :text
  add_column :part_descriptions, :lcv_wear, :text
  add_column :part_descriptions, :off_road_wear, :text
  end

  def down
  end
end
