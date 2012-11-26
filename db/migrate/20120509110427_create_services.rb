class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|      
      t.references  :service_plan, :null => false      
      t.text :name, :null => false
      t.float :multiply, :null => false
      t.decimal :labour, :precision => 8, :scale => 2, :null => false
      t.decimal :fixed_cost, :precision => 8, :scale => 2, :null => false
      t.timestamps
    end
    
    add_index :services, :service_plan_id
    
    add_foreign_key(:services, :service_plans, :name => 'services_service_plan_fk')
  end
end
