class RemoveColumnServicePlan < ActiveRecord::Migration
  def up
    remove_column :service_plans, :body_style
    remove_column :service_plans, :fuel_type
  end

  def down
  end
end
