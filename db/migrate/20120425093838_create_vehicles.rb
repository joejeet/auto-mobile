class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.text :fi_code, :null => false
      t.references  :manufacturer, :null => false
      t.references  :service_plan
      t.text :model, :null => false
      t.text :body_style, :null => false
      t.text :fuel_type, :null => false
      t.integer :doors, :null => false
      t.integer :engine_cc, :null => false
      t.integer :cylinders, :null => false
      t.integer :power_bhp, :null => false
      t.integer :power_ps, :null => false
      t.text :transmission, :null => false
      t.integer :number_of_gears, :null => false
      t.text :driven_wheels, :null => false
      t.text :status, :null => false
      t.datetime :live_datetime, :null => false
      t.timestamps
    end
   end
end
