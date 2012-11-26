class PartNumber < ActiveRecord::Base
  attr_accessible :part_id, :part_number
  
  belongs_to :part
  #validates_uniqueness_of :part_number
  
end
