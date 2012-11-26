class Country < ActiveRecord::Base
  attr_accessible :name, :country_code
  
  has_many :make_models
  has_many :vehicles

  has_many :regions
  
  def self.build_from_csv(row)
    country = find_or_initialize_by_name_and_country_code(row[1], row[0])
    if country.new_record?
      country.attributes ={:name => row[1], :country_code => row[0]}
    end
   return country
  end
end
