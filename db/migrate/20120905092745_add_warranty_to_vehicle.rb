class AddWarrantyToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :warranty_miles, :string
    add_column :vehicles, :warranty_months, :integer
  end
end
