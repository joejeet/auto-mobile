class Service < ActiveRecord::Base
  belongs_to :service_plan
  has_many :service_parts

  attr_accessible :name, :multiply, :labour, :miles, :months, :multiply

  validates  :labour, :presence => true

  def self.build_from_csv(row, service_index)
       
    if vehicle.new_record?
     vehicle.attributes = {:make_model_id =>model, 
     :country_code => row[1],
     :engine_cc => row[4], 
     :power_ps =>row[5], 
      :body_style => row[6],
      :doors => row[7],
      :fuel_type => row[8],      
      :cylinders => row[9],
      :transmission => row[10],
      :number_of_gears => row[11],
      :driven_wheels => row[12], 
      :status => "Live",
      :model_year=>"2012-1-1",
      :embargo_datetime =>"2012-8-1"}
    end
  return vehicle
  
  
  end  

end