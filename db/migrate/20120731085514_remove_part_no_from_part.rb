class RemovePartNoFromPart < ActiveRecord::Migration
  def up
    remove_column :parts, :part_number
  end

  def down
  end
end
