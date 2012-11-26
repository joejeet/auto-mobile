class GlobalCompanySetting < ActiveRecord::Base


  attr_accessible :country_id, :settings_file_id, :settings_session_id, :region_id, :lpg, :cost_per_litre_petrol, :cost_per_litre_diesel, 
:tyre_life_premium, :tyre_life_mid, :tyre_life_budget, :tyre_cost_premium, :tyre_cost_mid, :tyre_cost_budget, :last_service_exclusion_within_miles, 
:last_service_exclusion_within_percentage, :last_service_exclusion_within_month, :optimize_service_cost_for_fixed_variable, :optimize_service_cost_for_package_price, 
:MOT_one_month_early, :tyres_cost, :tyres_ppm, :valve_replacement, :balance


belongs_to :settings_file, :class_name => 'SettingsFile', :foreign_key => "settings_file_id"

belongs_to :settings_session, :class_name => 'SettingsSession', :foreign_key => "settings_session_id"


end

 



