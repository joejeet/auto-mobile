class AddColumnsToVehicle < ActiveRecord::Migration
  def change
  add_column :vehicles, :front_tyre, :string
  add_column :vehicles, :front_tyre_width, :string
  add_column :vehicles, :front_tyre_profile, :string
  add_column :vehicles, :front_tyre_type, :string
  add_column :vehicles, :front_tyre_diameter, :string
  add_column :vehicles, :front_tyre_speed_rating, :string
  add_column :vehicles, :rear_tyre, :string
  add_column :vehicles, :rear_tyre_width, :string
  add_column :vehicles, :rear_tyre_profile, :string
  add_column :vehicles, :rear_tyre_type, :string
  add_column :vehicles, :rear_tyre_diameter, :string
  add_column :vehicles, :rear_tyre_speed_rating, :string
  add_column :vehicles, :sump_capacity, :string
  add_column :vehicles, :gearbox_oil_capacity, :string
  add_column :vehicles, :rear_diff_oil_capacity, :string
  add_column :vehicles, :break_fluid_capacity, :string
  end
end
