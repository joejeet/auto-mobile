class MakeModel < ActiveRecord::Base
  attr_accessible :manufacturer_id, :country_id, :make, :make_code, :model, :model_code
  
  belongs_to :manufacturer
  has_many :vehicles
  belongs_to :country
    
  validates :manufacturer_id, :presence => true
  validates :country_id, :presence => true
  validates :model, :presence => true
  validates :model_code, :presence => true
  
  
  def self.build_from_csv(row,manufacturer)
  if row[0] !=nil
    country = Country.where("country_code=?",row[0]).first 
   model = find_or_initialize_by_make_code_and_model_and_country_id(row[2], row[4], country.id)
   if model.new_record?   
    model.attributes = {:manufacturer_id =>manufacturer, 
      :country_id =>country.id , 
      :make_code => row[2],
      :model => row[4],
      :model_code => row[3]}
   end
  return model
  end
  end
  
  def self.build_from_csv_new_car(row,manufacturer)
  err = []
   if row[1] !=nil and row[3] != nil and row[3] != "#N/A"
    country = Country.where("country_code=?",row[1]).first    
   model = MakeModel.where("make_code =? and model=? and country_id=? and manufacturer_id =?",row[2], row[3], country.id, manufacturer).first
   return model
   end
  end
  
  
  
  def self.search(search)
    if search
      find(:all, :conditions => ['make=? OR model=?',"#{search}","#{search}"])
    end
  end
end
