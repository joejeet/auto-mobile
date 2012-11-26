class RemoveFixedCostFromServices < ActiveRecord::Migration
  def up
    remove_column :services, :fixed_cost
  end

  def down
  end
end
