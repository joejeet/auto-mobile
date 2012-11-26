class Manufacturer < ActiveRecord::Base
 
 attr_accessible :name, :code

  has_many :make_models
  has_many :vehicles, :through => :make_models
  has_many :parts, :through => :manufacturer_parts
  has_many :manufacturer_parts  
  
  validates :name, :presence => true, :uniqueness => true
  validates :code, :presence => true
  
   def self.build_from_csv(row)
    manufacturer = find_or_initialize_by_name(row[2])
    if manufacturer.new_record?
      manufacturer.attributes ={:name => row[2], :code => row[1]}
    end
   return manufacturer
  end
  
  def self.build_from_csv_new_car(row)
    manufacturer = Manufacturer.where("name=?",row[2]).first
     return manufacturer  
  end
    
  def self.search(search)
    if search
      where('name ILIKE ?', "%#{search}%")
    end
  end
  
  def self.search_all
      find(:all)
  end
  
end
