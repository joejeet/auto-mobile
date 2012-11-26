class AddColumnToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :version, :text
    add_column :manufacturers, :code, :text
    remove_column :manufacturers, :manufacturer_code
  end
end
