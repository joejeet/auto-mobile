class RemoveSmrCodeFromVinImport < ActiveRecord::Migration
  def up
    remove_column :vin_imports, :smr_code
  end

  def down
    add_column :vin_imports, :smr_code, :string
  end
end
