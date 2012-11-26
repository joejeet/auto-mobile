class AddActiveStatusToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :active_status, :boolean, :default => true
  end
end
