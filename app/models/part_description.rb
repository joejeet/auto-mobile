class PartDescription < ActiveRecord::Base  
  attr_accessible :description,:below_300_wear_miles, :below_300_wear_months, :above_300_wear_miles, :above_300_wear_months, :lcv_wear_miles, :lcv_wear_months, :off_road_wear_miles, :off_road_wear_months
  has_many :parts
  
  validates :description, :presence => true, :uniqueness => true
  #validates :spread_miles, :spread_months, :presence => true

  def self.build_default_wear_rates_from_csv(row)
   description = find_or_initialize_by_description(row[0])   
   if description.new_record?
      description.attributes = {:description => row[0], :below_300_wear_miles =>row[1], :below_300_wear_months =>row[2], :above_300_wear_miles => row[3], :above_300_wear_months => row[4],
      :lcv_wear_miles => row[6], :lcv_wear_months => row[6], :off_road_wear_miles => row[7], :off_road_wear_months => row[8]}
      description.save!
   end     
 end
  
  
  def self.build_from_csv(row, wear_part_index, services_index)
    array_of_descriptions = []
   for i in (wear_part_index)..(services_index)-1   
       description = find_or_initialize_by_description(row[i])
   if description.new_record?
      description.attributes = {:description => row[i]}
      description.save!
   end   
      array_of_descriptions<<description.id<<i
  end
      return  array_of_descriptions
 end
   
end
