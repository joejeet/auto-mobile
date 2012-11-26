class ManufacturerPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :manufacturer
  
   attr_accessible :price, :part_id, :manufacturer_id
   accepts_nested_attributes_for(:part)
 end
