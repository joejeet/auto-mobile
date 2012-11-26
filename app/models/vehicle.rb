class Vehicle < ActiveRecord::Base
  BODY_STYLE = {'MPV' => 'MPV', 'SUV'=> 'SUV', 'Hatchback' => 'Hatchback', 'Saloon' => 'Saloon', 'Estate' => 'Estate', 'Coupe' => 'Coupe', 'Open Car' => 'Open Car', '4 X 4' => '4 X 4', 'People Carrier' => 'People Carrier', 'Cabriolet' => 'Cabriolet' }
  FUEL_TYPES = {"0" => "0","Diesel/Electric" => "Diesel/Electric", "Unleaded" => "Unleaded", "Diesel" => "Diesel", "Super Unleaded" => "Super Unleaded", "Super Unleaded/E85" => "Super Unleaded/E85", "Unleaded/Electric" => "Unleaded/Electric", "Electric" => "Electric", "Unleaded/LPG" => "Unleaded/LPG"}
  DOORS = {0=>0, 2 => 2, 3 => 3, 4 => 4, 5 => 5}
  CYLINDERS = {0 => 0, 2=>2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 8 => 8, 10 => 10, 12 => 12, 16 => 16, "V6" =>"V6"}
  TRANSMISSION = {"0" => "0", "Manual" => "Manual", "Automatic" => "Automatic"}
  GEARS = {0=>0, 1 => 1, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8}
  DRIVEN_WHEELS = {"0" => "0", "FWD" => "FWD", "RWD" => "RWD", "AWD" => "AWD", 4=>4}
  STATUS = {"Live" => "Live", "Discontinued" => "Discontinued", "Embargoed" => "Embargoed"}

  attr_accessible :front_tyre, :front_tyre_width, :front_tyre_profile, :front_tyre_type,:front_tyre_diameter, :front_tyre_speed_rating, :rear_tyre, :rear_tyre_width, :rear_tyre_profile, :rear_tyre_type, :rear_tyre_diameter,
   :rear_tyre_speed_rating, :sump_capacity,:gearbox_oil_capacity, :rear_diff_oil_capacity, :break_fluid_capacity, :trim, :warranty_miles, :warranty_months, :country_id, :version, :fi_code, :body_style, :fuel_type, :doors, :engine_cc, :cylinders, :power_bhp, :power_ps, :transmission, :number_of_gears, :driven_wheels, :status, :embargo_datetime, :service_plan_id, :make_model_id, :model_year

  before_create :fi_code_generator
  
  before_validation :convert_ps_in_range_of_bhp

  validates  :make_model_id, :body_style, :fuel_type, :doors, :engine_cc, :cylinders, :transmission, :number_of_gears, :driven_wheels, :status, :presence => true
  #validates_uniqueness_of :version
  validates_length_of :engine_cc, :maximum => 4
  validates :power_bhp, :presence => true, :numericality => { :only_integer => true }, :inclusion => { :in => 0..1500, :message => " %{value} bhp is not between 0 and 1500 bhp" }, :allow_blank => true
  validates :power_ps, :presence => true, :numericality => { :only_integer => true }, :inclusion => { :in => 0..1500, :message => " %{value} ps is not between 0 and 1500 ps" }, :allow_blank => true
  validates_inclusion_of :body_style, :in => BODY_STYLE.keys, :allow_blank => true
  validates_inclusion_of :fuel_type, :in => FUEL_TYPES.keys, :allow_blank => true
  validates_inclusion_of :doors, :in => DOORS.keys, :allow_blank => true
  validates_inclusion_of :cylinders, :in => CYLINDERS.keys, :allow_blank => true
  validates_inclusion_of :transmission, :in => TRANSMISSION.keys, :allow_blank => true
  validates_inclusion_of :number_of_gears, :in => GEARS.keys, :allow_blank => true
  validates_inclusion_of :driven_wheels, :in => DRIVEN_WHEELS.keys, :allow_blank => true
  validates_inclusion_of :status, :in => STATUS.keys, :allow_blank => true
  validate :retain_ps_in_range_of_bhp, :allow_blank => true

  has_and_belongs_to_many :service_plans do
  def fixed
      first(:conditions => {:fixed => 'F'})
    end
    def variable
      first(:conditions => {:fixed => 'V'})
    end
  end
  
  belongs_to :make_model
  has_one :manufacturer, :through => :make_model
  belongs_to :country
  
  def self.csv_header
    "FI Code, Country, Manufacturer, Model , Version, Engine_cc, Power_bhp, Power_ps, kw, Body Style, Fuel Type, Cylinders, Cylinder Configuration,
    Transmission Type, Transmmission Name, Number of Gears, Driven Wheels".split(',')
  end
  
  def to_csv
    [fi_code, country_code, manufacturer, model , version, engine_cc, power_bhp, power_ps, kw, body_style, fuel_type, cylinders, cylinder,
    transmission, transmmission , number_of_gears, driven_wheels]
  end
  
  def self.build_from_csv_smr(row, model)
    row[12] = "FWD" if row[12] =="F"
    row[12] = "RWD" if row[12] =="R"
    row[12] = "AWD" if row[12] =="4"
    row[9] = "6" if row[9] =="V6"    
    row[9] = "6" if row[9] =="V8"    
    row[9] = "6" if row[9] =="W12"  
    row[9] = "10" if row[9] =="V10" 
    row[9] = "10" if row[9] =="V12"
    row[6] = "Cabriolet" if row[6] =="Open Car"
    row[6] = "SUV" if row[6] =="4 X 4"
    row[10] = "Automatic" if row[10] =="Auto"
    country = Country.where("country_code=?",row[1]).first    
   
   vehicle = Vehicle.find_all_by_make_model_id_and_country_id_and_engine_cc_and_power_ps_and_body_style_and_doors_and_fuel_type_and_cylinders_and_transmission_and_number_of_gears_and_driven_wheels(model, country.id,row[4], row[5],row[6],row[7], row[8],row[9],row[10], row[11], row[12])
      
   return vehicle
  end
  
  def self.build_from_csv_new_car(row, model)
    row[18] = "FWD" if row[18] =="F"
    row[18] = "RWD" if row[18] =="R"
    row[18] = "AWD" if row[18] =="4"
    row[13] = "6" if row[13] =="V6"    
    row[13] = "6" if row[13] =="V8"    
    row[13] = "6" if row[13] =="W12"  
    row[13] = "10" if row[13] =="V10" 
    row[13] = "10" if row[13] =="V12"
    row[10] = "Cabriolet" if row[10] =="Open Car"
    row[10] = "SUV" if row[10] =="4 X 4"
    row[12] = "Unleaded" if row[12] =="Petrol"
    row[12] = "Unleaded/Electric" if row[12] =="Hybrid: Petrol/Electric"
    
    
  #row[15] = "0" if row[15]=="#N/A"
  #row[17] = 0 if row[17]=="#N/A"
  #row[18] = "0" if row[18]=="#N/A"
  if row[15]!="#N/A" or row[17]!="#N/A" or row[18]!="#N/A" or row[4]!="#N/A" or row[6]!="#N/A" or row[7]!="#N/A" or row[8]!="#N/A" or row[10]!="#N/A" or row[11]!="#N/A" or row[12]!="#N/A" or row[13]!="#N/A"  
  country = Country.where("country_code=?",row[1]).first
      vehicle = find_or_initialize_by_version_and_make_model_id_and_country_id_and_engine_cc_and_power_ps_and_body_style_and_doors_and_fuel_type_and_cylinders_and_transmission_and_number_of_gears_and_driven_wheels(row[4], model, country.id,row[6],row[8], row[10],row[11],row[12],row[13], row[15],row[17],row[18])
    if vehicle.new_record?
       vehicle.attributes = {:make_model_id =>model, 
        :country_id => country.id,
        :version =>row[4],
         :trim =>row[5],
        :engine_cc => row[6], 
        :power_bhp => row[7],
        :power_ps =>row[8], 
        :body_style => row[10],
        :doors => row[11],
        :fuel_type => row[12],      
        :cylinders => row[13],
        :transmission => row[15],
        :number_of_gears => row[17],
        :driven_wheels => row[18], 
        :warranty_miles => row[92],
        :warranty_months =>row[91],
        :front_tyre =>row[20],
        :front_tyre_width =>row[21],
        :front_tyre_profile =>row[22],
        :front_tyre_type =>row[23],
        :front_tyre_diameter =>row[24],
        :front_tyre_speed_rating =>row[25],
        :rear_tyre =>row[26],
        :rear_tyre_width =>row[27],
        :rear_tyre_profile =>row[28],
        :rear_tyre_type =>row[29],
        :rear_tyre_diameter =>row[30],
        :rear_tyre_speed_rating =>row[31],
        :sump_capacity =>row[39],
        :gearbox_oil_capacity =>row[40],
        :rear_diff_oil_capacity =>row[41],
        :break_fluid_capacity =>row[42],
        :status => "Live",
        :model_year=>"2012-8-1",
        :embargo_datetime =>"2012-8-1"}
       
     else 
        vehicle=nil
      end
      return vehicle
  end
  end
  

  private

  def self.filter_vehicles_or(manufacturer, make_model, body_style, fuel_type)
    joins(:manufacturer).where("manufacturer_id =? OR  make_model_id = ? OR body_style=? OR fuel_type=?", manufacturer, make_model, body_style, fuel_type)
  end

  def self.filter_vehicles_and(manufacturer, country, make_model, body_style, fuel_type, doors, engine_cc, cylinders, power_bhp, transmission, number_of_gears, driven_wheels, model_year)
    vehicles = joins(:manufacturer).where("manufacturer_id =? AND vehicles.country_id =? AND  make_model_id = ? AND body_style=? AND fuel_type=? AND doors=? AND engine_cc=? AND cylinders=? AND power_bhp=? AND transmission=? AND number_of_gears=? AND driven_wheels=? AND model_year=?",
     manufacturer, country, make_model, body_style, fuel_type, doors, engine_cc, cylinders, power_bhp, transmission, number_of_gears, driven_wheels, model_year)
     return vehicles
  end

  def fi_code_generator
    make = MakeModel.find(self.make_model_id)
    check_fi_code = "C#{make.country.country_code}#{make.manufacturer.code}#{make.model_code}"
    last_fi_code = Vehicle.where('fi_code LIKE ?', "%#{check_fi_code}%").last
    if  !last_fi_code.blank?
      self.fi_code = last_fi_code.fi_code.succ
    else
      self.fi_code = check_fi_code+"0001"
    end
  end

  def convert_ps_in_range_of_bhp
     if self.power_ps.blank? && !self.power_bhp.blank?
       self.power_ps = (self.power_bhp*1.01387).to_i
     end
     if !self.power_ps.blank? && self.power_bhp.blank?
       self.power_bhp = (self.power_ps/1.01387).to_i
     end
  end
  
  def retain_ps_in_range_of_bhp
    range = 10
    if !power_ps.nil? && !power_bhp.nil?
      unless (power_bhp-power_ps).abs <= range
        bhp = power_ps/1.01387
        ps = power_bhp*1.01387
        errors.add(:power_bhp, "value should be #{bhp.round(2)}bhp of #{power_ps}ps of  Power ps")
        errors.add(:power_ps, "value should be #{ps.round(2)}ps of #{power_bhp}bhp of Power bhp")
      end
    end
  end

  def self.search(search)
    if search
      joins(:make_model).where("model  ILIKE ? OR fi_code = ?","%#{search}%","#{search}")
    end
  end

end