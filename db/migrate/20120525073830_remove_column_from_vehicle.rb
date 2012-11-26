class RemoveColumnFromVehicle < ActiveRecord::Migration
  def up
    remove_column :vehicles, :model
  end

  def down
  end
end
