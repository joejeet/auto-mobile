class CreateServicePlanAndVehicleJoinTable < ActiveRecord::Migration
  def up
    create_table :service_plans_vehicles, :id => false do |t|
          t.integer :service_plan_id
          t.integer :vehicle_id
    end
  end

  def down
    drop_table :service_plans_vehicles
  end
end
