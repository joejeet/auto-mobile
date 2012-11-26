class AddAncestryToParts < ActiveRecord::Migration
  def change
    add_column :parts, :part_number, :string
    add_column :parts, :ancestry, :string
    add_index :parts, :ancestry
  end
end
