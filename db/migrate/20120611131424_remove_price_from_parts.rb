class RemovePriceFromParts < ActiveRecord::Migration
  def up
    remove_column :parts, :price
  end

  def down
  end
end
