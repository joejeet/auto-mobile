class CreateGlobalCompanySettings < ActiveRecord::Migration
  def change
    create_table :global_company_settings do |t|
      t.integer :country_id
      t.integer :settings_file_id
      t.integer :settings_session_id
      t.integer :region_id
      t.decimal :lpg
      t.decimal :cost_per_litre_petrol
      t.decimal :cost_per_litre_diesel
      t.decimal :tyre_life_premium
      t.decimal :tyre_life_mid
      t.decimal :tyre_life_budget
      t.decimal :tyre_cost_premium
      t.decimal :tyre_cost_mid
      t.decimal :tyre_cost_budget
      t.integer :last_service_exclusion_within_miles
      t.decimal :last_service_exclusion_within_percentage
      t.integer :last_service_exclusion_within_month
      t.boolean :optimize_service_cost_for_fixed_variable
      t.boolean :optimize_service_cost_for_package_price
      t.boolean :MOT_one_month_early
      t.string  :tyres_cost
      t.string  :tyres_ppm
      t.decimal :valve_replacement
      t.decimal :balance
      t.timestamps
    end
  end
end


