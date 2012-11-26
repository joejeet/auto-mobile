class FixedCost < ActiveRecord::Base
  
  belongs_to :service_plan
  
  attr_accessible :menu_pricing, :multiply, :miles
  
  validates  :menu_pricing, :presence => true 
end
