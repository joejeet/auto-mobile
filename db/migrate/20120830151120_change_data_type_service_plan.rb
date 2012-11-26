class ChangeDataTypeServicePlan < ActiveRecord::Migration
  def up
    remove_column :service_plans, :smr_code
    remove_column :service_plans, :interval_miles
    remove_column :service_plans, :interval_months
    remove_column :service_plans, :fixed
    remove_column :service_plans, :manufacturer
    remove_column :service_plans, :model
    add_column :service_plans, :smr_code, :string
    add_column :service_plans, :interval_miles, :integer
    add_column :service_plans, :interval_months, :integer
    add_column :service_plans, :fixed, :string, :length => 2
  end

  def down
  end
end
