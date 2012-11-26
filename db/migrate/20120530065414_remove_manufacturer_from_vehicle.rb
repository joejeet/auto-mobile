class RemoveManufacturerFromVehicle < ActiveRecord::Migration
  def up
    remove_column :vehicles, :manufacturer_id
    change_column :vehicles, :make_model_id, :integer, :null => false
  end

  def down
  end
end
