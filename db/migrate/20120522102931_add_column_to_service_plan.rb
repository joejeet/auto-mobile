class AddColumnToServicePlan < ActiveRecord::Migration
  def change
    add_column :service_plans, :manufacturer, :text
    add_column :service_plans, :model, :text
    add_column :service_plans, :body_style, :text
    add_column :service_plans, :fuel_type, :text
  end
end
