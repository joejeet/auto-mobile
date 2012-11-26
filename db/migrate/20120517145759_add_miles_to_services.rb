class AddMilesToServices < ActiveRecord::Migration
  def change
    add_column :services, :miles, :integer
    
  end
end
