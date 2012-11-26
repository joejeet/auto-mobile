class AddCountryIdModelVehicle < ActiveRecord::Migration
  def up
  add_column :make_models, :country_id, :integer
  add_column :vehicles, :country_id, :integer
  remove_column :make_models, :country_code
  remove_column :vehicles, :country_code
  end

  def down
  end
end
