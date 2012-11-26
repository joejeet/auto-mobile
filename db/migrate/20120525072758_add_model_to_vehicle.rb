class AddModelToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :make_model_id, :integer
  end
end
