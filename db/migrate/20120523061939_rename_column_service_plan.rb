class RenameColumnServicePlan < ActiveRecord::Migration
  def up
    rename_column :service_plans, :SMR_code, :smr_code
  end

  def down
  end
end
