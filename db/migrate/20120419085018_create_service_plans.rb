class CreateServicePlans < ActiveRecord::Migration
  def change
    create_table :service_plans do |t|
      t.text :SMR_code, :null => false
      t.text :interval_miles, :null => false
      t.text :interval_months, :null => false
      t.text :spread_miles, :null => false
      t.text :spread_months, :null => false
      t.text :fixed, :null => false
      t.datetime :live_datetime, :null => false
      t.timestamps
    end
  end
end
