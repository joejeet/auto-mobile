class AddColumnToManufacturer < ActiveRecord::Migration
  def change
    add_column :manufacturers, :manufacturer_code, :integer
  end
end
