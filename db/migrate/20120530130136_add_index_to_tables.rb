class AddIndexToTables < ActiveRecord::Migration
  def change
     add_index :vehicles, :make_model_id
    add_foreign_key(:vehicles, :make_models, :name => 'vehicles_make_model_fk')
    add_index :profile_parts, :part_id
    add_foreign_key(:profile_parts, :parts, :name => 'profile_parts_part_fk')
    add_index :make_models, :manufacturer_id
    add_foreign_key(:make_models, :manufacturers, :name => 'make_models_manufacturer_fk')
   end
end
