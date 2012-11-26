class AddIndexesToTables < ActiveRecord::Migration
    add_index :vehicles, :country_id
    add_foreign_key(:vehicles, :countries, :name => 'vehicles_country_fk')
    add_index :make_models, :country_id
    add_foreign_key(:make_models, :countries, :name => 'make_models_country_fk')
  def change
  end
end
