class ChangeColumnInPart < ActiveRecord::Migration
  def up
    change_column :parts, :interval_miles, :integer, :null => true
    change_column :parts, :interval_months, :text, :null => true
  end

  def down
  end
end
