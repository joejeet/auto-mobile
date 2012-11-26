class RemoveSpreadsFromParts < ActiveRecord::Migration
  def change
    remove_column :profile_parts, :spread_miles
    remove_column :profile_parts, :spread_months
  end
end