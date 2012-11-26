class AddFieldsToProfilePart < ActiveRecord::Migration
  def change
    add_column :profile_parts, :interval_miles, :integer
    add_column :profile_parts, :interval_months, :text
    add_column :profile_parts, :ll_interval_miles, :integer
    add_column :profile_parts, :ll_interval_months, :text
  end
end
