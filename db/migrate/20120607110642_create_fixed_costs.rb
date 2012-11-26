class CreateFixedCosts < ActiveRecord::Migration
  def change
    create_table :fixed_costs do |t|
      t.references  :service_plan, :null => false
      t.decimal  :menu_pricing, :precision => 8, :scale => 2, :null => false
      t.integer  :miles
      t.float    :multiply, :null => false
      t.timestamps
    end
    add_index :fixed_costs, :service_plan_id    
    add_foreign_key(:fixed_costs, :service_plans, :name => 'fixed_costs_service_plan_fk')
  end
end
