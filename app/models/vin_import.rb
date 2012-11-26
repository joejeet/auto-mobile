class VinImport < ActiveRecord::Base
  attr_accessible :body_style, :country, :cylinders, :doors, :driven_wheels, :engine_cc, :fuel_type, :honda_desc,
 :make_code, :model, :model_year, :number_of_gears, :power_ps, :reg_date, :smr_profile, :status, :transmission, :trim, :vin, :vrm

#belongs_to :service_plan, :foreign_key => 'smr_code', :primary_key => 'smr_profile'

  def self.csv_header 
     "VIN,VRM,Reg Date,SMR Code,Country,Manufacturer,Model,Engine CC,Power PS,Body Style,Doors,Fuel Type,Cylinders,Transmission,Number of Gears,
      Driven Wheels,MY,Status,SMR Profile,Trim,Honda Desc".split(',') 
  end 

  def self.build_from_csv(row)
    vin = find_or_initialize_by_vin(row[0]) 
    vin.attributes ={:vrm => row[1], 
    :reg_date => row[2], 
    :smr_code => row[3], 
    :country => row[4], 
    :make_code => row[5], 
    :model => row[6], 
    :engine_cc => row[7],
    :power_ps => row[8],
    :body_style => row[9], 
    :doors => row[10], 
    :fuel_type => row[11],
    :cylinders => row[12],
    :transmission => row[13], 
    :number_of_gears => row[14], 
    :driven_wheels => row[15],
    :model_year => row[16],
    :status => row[17], 
    :smr_profile => row[18], 
    :trim => row[19],
    :honda_desc => row[20]} 

    return vin 
  end 


  def to_csv 
    [vin, vrm, reg_date, smr_code, country, make_code, model, engine_cc, power_ps, body_style, doors, fuel_type, cylinders, transmission,        number_of_gears, driven_wheels, model_year, status, smr_profile, trim, honda_desc] 
  end
      
    
end
