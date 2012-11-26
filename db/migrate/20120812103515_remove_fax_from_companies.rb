class RemoveFaxFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :Fax
      end

  def down
    add_column :companies, :Fax, :string
  end
end
