class Inflation < ActiveRecord::Base
  attr_accessible :country_id, :fuel_above_y5, :fuel_y1, :fuel_y2, :fuel_y3, :fuel_y4, :fuel_y5, :labour_above_y5, :labour_y1, 
:labour_y2, :labour_y3, :labour_y4, :labour_y5, :oil_above_y5, :oil_y1, :oil_y2, :oil_y3, :oil_y4, :oil_y5, :parts_above_y5,
 :parts_y1, :parts_y2, :parts_y3, :parts_y4, :parts_y5, :region_id, :settings_file_id, :settings_session_id, :tyres_above_y5, 
:tyres_y1, :tyres_y2, :tyres_y3, :tyres_y4, :tyres_y5

belongs_to :settings_file, :class_name => 'SettingsFile', :foreign_key => "settings_file_id"

belongs_to :settings_session, :class_name => 'SettingsSession', :foreign_key => "settings_session_id"
end
