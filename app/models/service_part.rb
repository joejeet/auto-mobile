class ServicePart < ActiveRecord::Base
   attr_accessible :part_id, :service_id
  belongs_to :service
  belongs_to :part  
end
