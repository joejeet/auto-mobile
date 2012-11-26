class AddPartDescriptionToPart < ActiveRecord::Migration
  def change
    remove_column :part_descriptions, :part_id
    
    rename_column(:parts, :description, :part_description_id)    
    add_index(:parts, :part_description_id)
    add_foreign_key(:parts, :part_descriptions, :name => 'parts_part_description_fk')
  end
end