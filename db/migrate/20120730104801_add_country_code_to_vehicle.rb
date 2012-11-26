class AddCountryCodeToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :country_code, :text
  end
end
