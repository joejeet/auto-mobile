class ChangeColumnServicePlan < ActiveRecord::Migration
  def up
    remove_column :service_plans, :spread_miles
    remove_column :service_plans, :spread_months
  end

  def down
  end
end
