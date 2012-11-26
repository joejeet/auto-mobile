class AddEmbargoDateToDb < ActiveRecord::Migration
  def change
     add_column :vehicles, :embargo_datetime, :datetime
     add_column :parts, :embargo_datetime, :datetime
     add_column :service_plans, :embargo_datetime, :datetime
     remove_column :vehicles, :live_datetime
     remove_column :parts, :live_datetime
     remove_column :service_plans, :live_datetime
  end
end
