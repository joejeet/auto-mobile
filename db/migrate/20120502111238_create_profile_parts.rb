class CreateProfileParts < ActiveRecord::Migration
  def change
    create_table :profile_parts do |t|
      t.references  :service_plan, :null => false
      t.integer :part_id, :null => false
      t.float :price, :null => false
      t.float :labour_time, :null => false
      t.integer :spread_miles, :null => false
      t.text :spread_months, :null => false
      t.timestamps
    end
    
    add_index :profile_parts, :service_plan_id
    
    add_foreign_key(:profile_parts, :service_plans, :name => 'profile_parts_service_plan_fk')
  end
end
