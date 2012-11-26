class RemoveColumnProfilePart < ActiveRecord::Migration
  def up
  remove_column :profile_parts, :price
  add_column :profile_parts, :price, :decimal, :precision => 8, :scale => 2
  end

  def down
  end
end
