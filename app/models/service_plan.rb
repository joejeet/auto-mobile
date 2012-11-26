class ServicePlan < ActiveRecord::Base
  attr_accessible :smr_code, :fixed, :interval_miles, :interval_months, :embargo_datetime, :vehicle_ids, :service_id, :services_attributes, :fixed_costs_attributes, :profile_parts_attributes, :manufacturer, :model, :body_style, :fuel_type, :id, :created_at, :updated_at

  before_create :prepare_for_create, :prepare_fixed_costs
   
  has_and_belongs_to_many :vehicles
  has_many :profile_parts
  has_many :parts, :through => :profile_parts
  has_many :services
  has_many :service_parts, :through => :services
  has_many :fixed_costs
  #has_many :vin_imports, :primary_key => 'smr_code', :foreign_key => 'smr_code'
  
  accepts_nested_attributes_for :fixed_costs,  :allow_destroy => true

  validates :smr_code, :presence => true
  validates :interval_miles, :interval_months, :fixed, :embargo_datetime, :presence => true
  validates :services, :length => { :minimum => 1}
  validate :smr_code_count_per_vehicle, :on=> :create
  


  def smr_code_count_per_vehicle
    return if vehicles.blank?
    errors.add("Vehicle contains more than two profiles") if vehicles.first.service_plans.length > 2
  end

  accepts_nested_attributes_for(:profile_parts, :allow_destroy => true, :reject_if => :all_blank)
  accepts_nested_attributes_for(:services, :allow_destroy => true, :reject_if => :all_blank)
  
    
 def self.calculate_all_total_costs(x_miles=60000, x_month=36)
    all.each do |service_plan|
      service_plan.calculate_profile_total_cost(x_miles, x_month)
    end
  end
  
  def inflation_parts(months, part_price)
  part_inflation_factor_year1 = 0.00417
  part_inflation_factor_year2 = 0.00333
  part_inflation_factor_year3 = 0.00333
  part_inflation_factor_year4 = 0.00249
  
  if months<=12
  new_price = (part_price + ((months)*(part_inflation_factor_year1)*(part_price)))  
  elsif months >12 and months <=24
  new_price = (part_price + ((part_price)*(part_inflation_factor_year2)*(months -12)+(12* part_inflation_factor_year1)))
  elsif months >24 and months <=36
  new_price = (part_price + ((part_price)*(part_inflation_factor_year3)*(months -24)+(24* part_inflation_factor_year2)))
   elsif months >36 and months <=48
  new_price = (part_price + ((part_price)*(part_inflation_factor_year4)*(months -36)+(36* part_inflation_factor_year3)))
  end
  return new_price
  end
  
 def service_part_cal(service_labour_rate,service_part_discount, x_miles, part_arr)
  @return_service_hash = {'service_parts' =>[],'service_labour' =>[],'service_parts_rate' =>[],'service_parts_total_rate' =>[],'service_parts_smr_rate' =>[]}
                        service_parts = []
                        service_labour = []
                       service_parts_rate = []
                       service_parts_total_rate = []
                       service_parts_smr_rate = []
                    part_arr.each do |part|
                       service_parts<<part
                        service_number = (x_miles.to_i/part.interval_miles.to_i).abs 
                        labour = (part.labour_time * service_labour_rate).round(2)
                        part_price = ((part.price) - (part.price*service_part_discount)).round(2)
                        service_labour<<labour
                        service_parts_rate<<part_price
                        service_parts_total_rate <<(labour + part_price).round(2)
                        service_parts_smr_rate<<((labour + part_price) * service_number).round(2)  
                    end
                        @return_service_hash['service_parts']<<service_parts
                        @return_service_hash['service_labour']<<service_labour
                       @return_service_hash['service_parts_rate']<<service_parts_rate
                        @return_service_hash['service_parts_total_rate'] <<service_parts_total_rate
                        @return_service_hash['service_parts_smr_rate']<<service_parts_smr_rate                          
  return @return_service_hash
  end
  
def calculate_profile_total_cost(x_miles=60000, x_month=36)
    return @return_hash if defined?(@return_hash) #Joe needs testing
    
    miles_pa = x_miles.to_i/(x_month.to_i/12)
    service_labour_rate = 60.00
    service_labour_discount=0.0
    service_part_discount= 0.0
    inflation_factor = 0.05
   # modelling_range_low = 11000
    modelling_range_low_factor = 0.0
    #modelling_range_high = 33000
    modelling_range_high_factor = 0.0
    wear_labour_discount = 0.0
    wear_labour_rate = 60.00
    wear_part_discount= 0.0
    capacity = 1.0
    @return_hash = {'part_inflation' =>[], 'contract_service_array' =>[], 'wear_description' => [], 'service_labour_cost' => [], 'services_cost' => [], 'service_description' => [], 'wear_parts_smr_rate' => [], 'wear_parts_total_rate' => [], 'fluid_labour' =>[], 'fluid_parts' => [], 'fluid_parts_rate' => [], 'fluid_parts_smr_rate' => [], 'fluid_parts_total_rate' => [], 'services' => [], 'service_parts_smr_rate' => [], 'service_parts_total_rate' => [], 'total_cost' =>[], 'oow_miles_months' => [], 'vehicle' => [], 'service_labour' =>[], 'service_parts' => [], 'service_parts_rate' => [], 'service_cost' => [],  'wear_labour' =>[], 'wear_parts' => [], 'wear_parts_rate' => [], 'wear_cost' => []}
        
     services = []
     service_parts = []
     service_labour = []
     service_parts_rate = []
     service_parts_total_rate = []
     service_parts_smr_rate = []
     fluid_parts = []
     fluid_labour = []
     fluid_parts_rate = []
     fluid_parts_total_rate = []
     fluid_parts_smr_rate = []
     wear_parts = []
     wear_parts_rate = []
     wear_labour = []    
     wear_parts_total_rate = []
     wear_parts_smr_rate = []     
     oow_miles_months = []
     service_description = []
     service_labour_cost = []
     services_cost = []
     wear_description =[]
     part_inflation = [] 
      desc = PartDescription.find_all_by_below_300_wear_miles("Service")
      service_description << desc.collect(&:description)
      desc = PartDescription.where("below_300_wear_miles!=?", "Service")
      wear_description << desc.collect(&:description)
      
        service_arr = self.services.delete_if {|x| x.miles > x_miles.to_i }
        mile_array = service_arr.collect(&:miles)        
        mile = self.interval_miles
        new_service_arr =[]
        while x_miles.to_i >= mile do 
             new_service_arr<<  mile
             mile += self.interval_miles
        end
        new_service_months =[]
        new_service_arr.each do |serv|
           
           check_service = service_arr[check_divisible_service(serv, mile_array)]
           services << check_service
           s_labour = ( check_service.labour* service_labour_rate).round(2)
           service_labour_cost << s_labour
           services_cost << (((s_labour) - (s_labour * service_labour_discount)) * calculate_service_compute_time(x_miles.to_i, check_service.miles, mile_array)).round(2)
         if !check_service.service_parts.blank?
               part_arr =   Part.find_all_by_id(check_service.service_parts.collect(&:part_id))
                service_part_cal(service_labour_rate,service_part_discount, x_miles, part_arr)       
          end           
                service_parts<<@return_service_hash['service_parts']           
                service_labour<<@return_service_hash['service_labour']
                service_parts_rate<<@return_service_hash['service_parts_rate']
                service_parts_total_rate<<@return_service_hash['service_parts_total_rate']
                service_parts_smr_rate<<@return_service_hash['service_parts_smr_rate']
                part_inflation<< inflation_parts(((serv/x_miles.to_f)*x_month.to_i).round, @return_service_hash['service_parts_rate'].flatten.inject(0, :+))
     end
               
      Part.find_all_by_id(self.profile_parts.collect(&:part_id)).each do |part|
      if part.part_type == 'F'
        if part.interval_months != "n/a" and part.price !=0.0
             fluid_parts << part
             compute_number = (x_month.to_i/part.interval_months.to_i).abs
             calc_labour = (part.labour_time * service_labour_rate).round(2)
             part_price = (part.price*capacity).round(2)
             fluid_labour << calc_labour
              fluid_parts_rate << part_price
              fluid_parts_total_rate << (calc_labour + part_price).round(2)
              fluid_parts_smr_rate << ((calc_labour + part_price) * compute_number).round(2)     
         end      
      elsif part.part_type == 'W'  
         vehicle = self.vehicles.first        
          if vehicle.power_bhp <=300
          part_description_below_300_miles = part.part_description.below_300_wear_miles
          part_description_below_300_months = part.part_description.below_300_wear_months
             if !part_description_below_300_miles.nil?
                 if part_description_below_300_miles.split.last != "Service"
                      part_standard_life = part_description_below_300_miles
                 end
             elsif !part_description_below_300_months.nil?
                   part_standard_life = part_description_below_300_months + " months"
             end
          else
            part_description_above_300_miles = part.part_description.above_300_wear_miles
            part_description_above_300_months = part.part_description.above_300_wear_months
            if !part_description_above_300_miles.nil?
                 if part_description_above_300_miles.split.last != "Service"
                      part_standard_life = part_description_above_300_miles
                 end
           elsif !part_description_above_300_months.nil?
                   part_standard_life = part_description_above_300_months + " months"
            end
         end         
          if !part_standard_life.nil? and part.labour_time != 0.0               
            if part_standard_life.split.last != "months" and part_standard_life.split.last != "Breakdown"
              if modelling_range_low_factor !=0.0 and modelling_range_high_factor != 0.0
                revise_life = (part_standard_life.to_i * modelling_range_low_factor).round  if miles_pa <= modelling_range_low
                revise_life = (part_standard_life.to_i * modelling_range_high_factor).round if miles_pa >= modelling_range_high
                revise_life = part_standard_life.to_i  if miles_pa < modelling_range_high and miles_pa > modelling_range_low 
                replacement  = x_miles.to_i/revise_life 
             else
               replacement  = x_miles.to_i/part_standard_life.to_i
             end
             if part.price != 0.0
                wear_parts << part.part_description.description   
                parts_rate = (part.price) - (part.price*wear_part_discount)
                wear_labour_cost = ((part.labour_time * wear_labour_rate) - (part.labour_time * wear_labour_rate * wear_labour_discount)).round(2)
                wear_parts_rate <<  parts_rate
                wear_labour << wear_labour_cost
                wear_parts_total_rate << (wear_labour_cost + parts_rate).round(2)         
                wear_parts_smr_rate << ((wear_labour_cost + parts_rate)* replacement).round(2)
             end              
          elsif part_standard_life.split.last == "months" 
                replacement = x_month.to_i/part_standard_life.to_i 
              if part.price != 0.0
                wear_parts << part.part_description.description    
                parts_rate = (part.price) - (part.price*wear_part_discount)
                wear_labour_cost = ((part.labour_time * wear_labour_rate) - (part.labour_time * wear_labour_rate * wear_labour_discount)).round(2)
                wear_parts_rate <<  parts_rate
                wear_labour << wear_labour_cost
                wear_parts_total_rate << (wear_labour_cost + parts_rate).round(2)         
                wear_parts_smr_rate << ((wear_labour_cost + parts_rate)* replacement).round(2) 
              end                
          elsif part.part_description.above_300_wear_miles.split.last == "Breakdown" 
                if vehicle.warranty_miles == "Unlimited"
                    warranty_miles = 999999
                else
                    warranty_miles = vehicle.warranty_miles.to_i                  
                end                                 
                warranty_term = (vehicle.warranty_months)*12           
               if warranty_term < x_month and warranty_miles < x_miles 
                  month_oow =  x_month - warranty_term 
                  miles_oow = (warranty_miles - x_miles).abs 
               elsif warranty_term > x_month and warranty_miles < x_miles
                  month_oow = (x_miles - warranty_miles)/(x_miles/x_month)
                  miles_oow = (warranty_miles - x_miles).abs
               elsif warranty_term < x_month and warranty_miles > x_miles
                  month_oow =  x_month - warranty_term
                  miles_oow = (x_miles/x_month)*month_oow                             
              end
              if part.price != 0.0
                oow_miles_months << part.id << miles_oow << month_oow 
                wear_parts << part.part_description.description 
                parts_rate = (part.price) - (part.price*wear_part_discount)
                wear_labour_cost = ((part.labour_time * wear_labour_rate) - (part.labour_time * wear_labour_rate * wear_labour_discount)).round(2)
                wear_parts_rate <<  parts_rate
                wear_labour << wear_labour_cost
                wear_parts_total_rate << (wear_labour_cost + parts_rate).round(2)
                wear_parts_smr_rate << (0.0)
               end                        
          end
         end
        end
      end
         @return_hash['part_inflation'] << part_inflation 
         @return_hash['contract_service_array'] << new_service_arr
         @return_hash['vehicle'] << self.vehicles.collect(&:id)  
         @return_hash['wear_description'] << wear_description[0]
         @return_hash['service_labour_cost'] << service_labour_cost
         @return_hash['services_cost'] << services_cost
         @return_hash['service_description'] << service_description[0]
         @return_hash['oow_miles_months'] << oow_miles_months
         @return_hash['service_parts'] << service_parts
         @return_hash['service_parts_rate'] << service_parts_rate 
         @return_hash['service_labour'] << service_labour
         @return_hash['service_parts_total_rate'] << service_parts_total_rate
         @return_hash['service_parts_smr_rate'] << service_parts_smr_rate
         @return_hash['fluid_parts'] << fluid_parts
         @return_hash['fluid_parts_rate'] << fluid_parts_rate 
         @return_hash['fluid_labour'] << fluid_labour
         @return_hash['fluid_parts_total_rate'] << fluid_parts_total_rate
         @return_hash['fluid_parts_smr_rate'] << fluid_parts_smr_rate
         @return_hash['services'] << services
         @return_hash['service_cost'] << ((service_parts_smr_rate.flatten.inject(0, :+)) +(fluid_parts_smr_rate.inject(0, :+)) + (services_cost.inject(0, :+))).round(2)
         @return_hash['wear_parts'] << wear_parts
         @return_hash['wear_parts_rate'] << wear_parts_rate  
         @return_hash['wear_parts_total_rate'] << wear_parts_total_rate if wear_parts_total_rate
         @return_hash['wear_parts_smr_rate'] << wear_parts_smr_rate if wear_parts_smr_rate
         @return_hash['wear_labour'] << wear_labour
         @return_hash['wear_cost'] = (wear_parts_smr_rate.inject(0, :+)).round(2)
         @return_hash['total_cost'] =  (@return_hash['wear_cost'] + @return_hash['service_cost'].inject(0, :+) ).round(2)
      return @return_hash
  end

  def calculate_service_compute_time(x_miles, mile, mile_arr)        
    service_arr =[]
    compute_number = 0
    while x_miles >= mile do 
        service_arr<< mile
        mile +=self.interval_miles
     end
     service_arr.each do |value|
       if(mile_arr.include?(value))
          compute_number += 1
       end
     end
     return compute_number
  end    


  def self.build_from_csv_smr(row, smr_vehicles, total_parts, service_index, last_index)
    errs =[]
  
     if smr_vehicles[0].service_plans.blank? and  smr_vehicles[0].service_plans.count < 2 and row[service_index] !="NO DATA" and !row[service_index].blank?
        parts_array = total_parts.flatten.chunk { |x| x != '/' }.select(&:first).map(&:last)  
     if row[service_index+3] !="" and !row[service_index+3].nil?
        labour_rate_std_service = []
        multiplier_std_service = []
        miles_std_service = []
        months_std_service = []
        (service_index+3..last_index).step(8).each do |s|
          if row[s] !="n/a" and row[s] !="" and row[s] != "NO DATA" and !row[s].nil? and row[s] != '0'  
          miles_std_service<<row[s-3]
          months_std_service<<row[s-2]
          multiplier_std_service<<row[s-1]
          labour_rate_std_service<<row[s]
          end
        end
        service_plan = ServicePlan.new
        service_plan.vehicles = smr_vehicles
        get_smr = service_plan.generate_smr(smr_vehicles[0])
        service_plan.attributes = {:smr_code =>get_smr, :fixed =>"F", :interval_miles => row[service_index], :interval_months => row[service_index+1], :embargo_datetime =>"2012-8-1"}
          
        for p in 0..parts_array.count-1              
        if parts_array[p].count ==3 and parts_array[p][1] !=nil                     
           service_plan.profile_parts.build(:part_id =>parts_array[p][0], :labour_time => parts_array[p][1] , :price => parts_array[p][2])
        elsif parts_array[p].count ==1 
           part_profile = Part.find(parts_array[p][0])
           service_plan.profile_parts.build(:part_id =>part_profile.id, :labour_time => part_profile.labour_time )            
        end       
        end                          
        for lab in 0..labour_rate_std_service.count-1
         service_plan.services.build(:name => "Service#{lab+1}", :labour =>labour_rate_std_service[lab], :miles =>miles_std_service[lab], :months =>months_std_service[lab], :multiply =>multiplier_std_service[lab])
        end          
         mile_array = service_plan.services.collect(&:miles)
          service_parts = Part.find_all_by_id_and_part_type(service_plan.profile_parts.collect(&:part_id), 'S')
          service_parts.each do |part|    
                      
          index = service_plan.check_divisible_service(part.interval_miles, mile_array.reverse)
      
                service_plan.services.reverse[index].service_parts.build(:part_id => part.id)         
             end
           if service_plan.valid?
            service_plan.save!
          else
            errs<<row
          end 
       else
             errs<<row
       end
       if row[service_index+7] !="" and row[service_index+7] != "NO DATA" and !row[service_index+7].nil? and !row[service_index+7] !=0
        labour_rate_ll_service = []
        multiplier_ll_service = []
        miles_ll_service = []
        months_ll_service = []
         (service_index+7..last_index).step(8).each do |s|
          if row[s]!="n/a" and row[s] !="" and row[s] != "NO DATA" and !row[s].nil? and row[s] != '0'
            miles_ll_service<<row[s-3]
            months_ll_service<<row[s-2]
            multiplier_ll_service<<row[s-1]
            labour_rate_ll_service<<row[s]
          end
         end
         service_plan = ServicePlan.new
         service_plan.vehicles = smr_vehicles
         get_smr = service_plan.generate_smr(smr_vehicles[0])
         service_plan.attributes ={:smr_code =>get_smr, :fixed =>"V", :interval_miles => row[service_index+4], :interval_months => row[service_index+5], :embargo_datetime =>"2012-8-1"}
         for p in 0..parts_array.count-1              
           if parts_array[p].count ==3 and parts_array[p][1] !=nil                        
             service_plan.profile_parts.build(:part_id =>parts_array[p][0], :labour_time => parts_array[p][1] , :price => parts_array[p][2])
           elsif parts_array[p].count ==1 
             part_profile = Part.find(parts_array[p][0])
             service_plan.profile_parts.build(:part_id =>part_profile.id, :labour_time => part_profile.labour_time )            
           end       
         end                               # Creating Part Number
         for lab in 0..labour_rate_ll_service.count-1
          service_plan.services.build(:name => "Service#{lab+1}", :labour =>labour_rate_ll_service[lab], :miles =>miles_ll_service[lab], :months =>months_ll_service[lab], :multiply =>multiplier_ll_service[lab])
         end
         mile_array = service_plan.services.collect(&:miles)
          service_parts = Part.find_all_by_id_and_part_type(service_plan.profile_parts.collect(&:part_id), 'S')
          service_parts.each do |part|                 
          index = service_plan.check_divisible_service(part.interval_miles, mile_array.reverse)
          
                service_plan.services.reverse[index].service_parts.build(:part_id => part.id) if !index.nil?
          end
          if service_plan.valid?
            service_plan.save!
          else
            errs<<row
          end 
        else
            errs<<row
        end 
      else
          errs<<row
      end
        return errs
   end 
  
  def check_divisible_service(mile, mile_array)
   divisible_service_index = []
  mile_array.each_with_index do |ml, index|
     if (mile%ml) == 0
        divisible_service_index<< index              
    end            
  end
    return divisible_service_index.first if divisible_service_index  
   end
  
  
  def generate_smr(vehicle)
    smr =  "#{vehicle.make_model.country.country_code.upcase}"+"#{vehicle.manufacturer.code.upcase}"+"#{vehicle.make_model.model_code.upcase}"+"#{vehicle.body_style}"[0.1]+"#{smr_fuel_type_code(vehicle)}"[0..1]+"#{vehicle.doors}"[0.1]+"#{vehicle.engine_cc}"[0..3]+
              "0#{vehicle.cylinders}"[0..1]+"#{vehicle.power_bhp}"[0..2]+"#{vehicle.transmission}"[0.1]+"#{vehicle.number_of_gears}"[0.1]+"#{vehicle.driven_wheels}"[0.1]+"#{vehicle.model_year.year}"[2..4]+model_year_month("#{vehicle.model_year.month}")
    return smr
  end
  
  def model_year_month(month)
    ('A'..'Z').each_with_index do |alphabet,index| 
      return alphabet if (index==month.to_i - 1) 
      end
  end
  
  
  def smr_fuel_type_code(vehicle)
         return fuel_type_code = "DS"  if vehicle.fuel_type == "Diesel"
         return fuel_type_code = "UL"  if vehicle.fuel_type == "Unleaded"
         return fuel_type_code = "SU"  if vehicle.fuel_type == "Super Unleaded"
         return fuel_type_code = "PE"  if vehicle.fuel_type == "Unleaded/Electric"
         return fuel_type_code = "EE"  if vehicle.fuel_type == "Electric"
         return fuel_type_code = "PL"  if vehicle.fuel_type == "Unleaded/LPG"             
  end
  
  def self.filter_vehicles_and(manufacturer, make_model, body_style, fuel_type, doors, engine_cc, cylinders, power_bhp, transmission, number_of_gears, driven_wheels, model_year)
    joins(:vehicles => :manufacturer).where("manufacturer_id =? AND  make_model_id = ? AND body_style=? AND fuel_type=? AND doors=? AND engine_cc=? AND cylinders=? AND power_bhp=? AND transmission=? AND number_of_gears=? AND driven_wheels=? AND model_year=?",
    manufacturer, make_model, body_style, fuel_type, doors, engine_cc, cylinders, power_bhp, transmission, number_of_gears, driven_wheels, model_year)
  end

  def self.filter_vehicles_or(manufacturer, make_model, body_style, fuel_type, doors, engine_cc, cylinders, power_bhp, transmission, number_of_gears, driven_wheels, model_year)
    joins(:vehicles).where("manufacturer_id =? OR  make_model_id = ? OR body_style=? OR fuel_type=? OR doors=? OR engine_cc=? OR cylinders=? OR power_bhp=? OR transmission=? OR number_of_gears=? OR driven_wheels=? OR model_year=?",
    manufacturer, make_model, body_style, fuel_type, doors, engine_cc, cylinders, power_bhp, transmission, number_of_gears, driven_wheels, model_year)
  end

  def prepare_fixed_costs
    fixed_rate =    self.fixed_costs.collect(&:menu_pricing)
    self.fixed_costs = []
    generate_fixed_costs(fixed_rate, interval_miles)
  end

  def generate_fixed_costs(fixed_rate, base_mile)
    fixed_rate.each_with_index do|value,index|
      mile = (index+1) *base_mile.to_i
      self.fixed_costs.build(:multiply => (index+1), :menu_pricing => value, :miles => mile)
    end
  end

  def generate_clone
    cloned = self.dup({:include => [:services, :profile_parts, :fixed_costs],  :except => [:smr_code, :created_at, :updated_at]})
    return cloned
  end

  def prepare_for_create
    if self.services.collect(&:miles).count == 0 and self.services.collect(&:months).count ==0
        lb_rate = self.services.collect(&:labour)
        service_profile =  self.services.collect(&:service_plan_id).first
        self.services = [] if !service_profile
        generate_services get_services(lb_rate, interval_miles)
    end
  end

  def generate_services(services_hash)
    service_profile =  self.services.collect(&:service_plan_id).first
    if service_profile.blank?
      services_hash['services'].each_with_index do|value,index|
        self.services.build(:name => value, :multiply => (services_hash['miles'][index]/services_hash['miles'].first), :labour => services_hash['ib_rate'][index], :miles => services_hash['miles'][index])
      end
    else
      services_hash['services'].each_with_index do|value,index|
        self.services.update_all(:name => value, :multiply => (services_hash['miles'][index]/services_hash['miles'].first), :labour => services_hash['ib_rate'][index], :miles => services_hash['miles'][index])
      end
    end
  end

  def get_services(ib_rate, base_mile)
    return_hash = {'services' => ['Service1'], 'miles' =>[base_mile.to_i], 'ib_rate' => [ib_rate[0] ] }
    ib_rate.each_with_index do|value,index|
      if index >= 1
        mile = (index+1) *base_mile.to_i
        last_mile = get_last_divisible_mile(return_hash, mile)
        index_of_last_mile = return_hash['miles'].index(last_mile)
        return_hash['ib_rate'][index_of_last_mile]
        if value != return_hash['ib_rate'][index_of_last_mile]
          return_hash['miles']  << mile
          return_hash['ib_rate'] << value
          return_hash['services'] << "Service#{return_hash['services'].count + 1}"
        end
      end
    end
    return return_hash
  end

  def get_last_divisible_mile(serices_hash,mile)
    last_divisible_mile = serices_hash['miles'][0]
    quit = false
    serices_hash['miles'].reverse.each do|ml|
      if (mile%ml).zero?
      last_divisible_mile = ml
      quit = true
      end
      break if quit
    end
    return last_divisible_mile
  end
end
