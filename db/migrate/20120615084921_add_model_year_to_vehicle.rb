class AddModelYearToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :model_year, :integer
  end
end