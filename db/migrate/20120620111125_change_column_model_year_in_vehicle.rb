class ChangeColumnModelYearInVehicle < ActiveRecord::Migration
  def up
    #change_column(:vehicles, :model_year, :datetime, :null => false)
    
    remove_column(:vehicles, :model_year)
    add_column :vehicles, :model_year, :datetime,  :null => false
  end

  def down
   end
end
