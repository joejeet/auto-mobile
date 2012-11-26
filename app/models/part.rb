class Part < ActiveRecord::Base
  PART_TYPES = {'S' => "Service", 'W' => 'Wear', 'F' => 'Fluid'}
  
  attr_accessible :price, :parent_id, :part_number, :manufacturer_parts_attributes, :labour_time, :interval_miles, :interval_months, :ll_interval_miles, :ll_interval_months, :part_type, :embargo_datetime, :part_description_id, :calculate_price
  
 # validates :interval_miles, :numericality => { :only_integer => true }, :allow_nil => true, :inclusion => { :in => 5000..300000, :message => " %{value} miles is not between 5K and 30K miles" }
  #validates :ll_interval_miles, :numericality => { :only_integer => true }, :allow_nil => true, :inclusion => { :in => 5000..300000, :allow_nil => true }
  validates_format_of :labour_time, :with => /^\d+\.?\d{0,2}$/, :allow_nil => true
  #validates :labour_time, :length => { :is => 5 ,:message => " Only 4 digits allowed"  }, :allow_nil => true ????????
  validates  :part_type, :embargo_datetime, :part_description_id, :presence => true
  validates_inclusion_of :part_type, :in => PART_TYPES.keys, :allow_blank => true
   validates :interval_miles, :interval_months, :presence => true, :if => :service_part?
   #validates :part_numbers, :length => { :minimum => 1}
 
  has_ancestry  
  has_many :service_parts
  has_many :service_plans, :through => :profile_parts
  has_many :profile_parts
  belongs_to :part_description
 
  #accepts_nested_attributes_for :part_numbers, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :profile_parts, :allow_destroy => true
 
   
 def self.build_from_csv(row, description, index, manufacturer)
    
   @errs =[]
    row[index[0]] = 0 if row[index[0]] =="n/a"
       
  if index.count == 3
  @total_parts = []
  @labour_array = []
  row[index[2]] = 0 if row[index[2]]=="n/a"
  check_fluid = PartDescription.find(description).description.split.include? 'Fluid' 
   if row[index[1]] !="n/a" and row[index[1]] !="0" and !row[index[1]].blank? or !check_fluid.blank?
      if row[index[1]] !="n/a" and row[index[1]] !="0" and !row[index[1]].blank?
    array_of_part_nums = row[index[1]].split(",")    #Converting Part no.'s into array
     if array_of_part_nums.count >=1
     array_of_part_nums.each do |part_no|
       check_part_description = Part.where("part_description_id=?", description).first   #Checking part description if it already exists
       if PartDescription.find(description).description.split.include? 'Fluid'
          part_type = "F"
       else
          part_type = "W"
       end
       check_part_number = Part.where("part_number = ?", part_no).first   #Checking part no. if it already exists
        if check_part_number.blank? and check_part_description.blank?
        
          smr_wear_part = Part.new({:part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :price => row[index[2]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save
          @total_parts<<smr_wear_part.id<<"/"
        elsif !check_part_number.blank? and check_part_description.blank?
          smr_wear_part = Part.new({:parent_id =>check_part_number.id, :part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :price => row[index[2]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save
          @total_parts<<smr_wear_part.id<<"/"
        elsif check_part_number.blank? and !check_part_description.blank?
         smr_wear_part = Part.new({:parent_id =>check_part_description.id, :part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :price => row[index[2]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save
          @total_parts<<smr_wear_part.id<<"/"
        elsif !check_part_number.blank? and !check_part_description.blank?
          if check_part_number.labour_time.to_s !=row[index[0]] and row[index[0]] != nil and !row[index[0]].blank?
             @labour_array<<check_part_number.id<<row[index[0]]<<row[index[2]]<<"/"
          else
            @labour_array<<check_part_number.id<<"/"
          end
          end
        end            
       end    
      end
    end      
  end
  
  if index.count == 5
  @total_parts = []
  @labour_array = []
    row[index[1]] = "" if row[index[1]] =="n/a"
    row[index[2]] = "" if row[index[2]] =="n/a"
    row[index[4]] = 0 if row[index[4]]=="n/a"
    check_fluid = PartDescription.find(description).description.split.include? 'Fluid' 
  if row[index[3]] !="n/a" and row[index[3]] !="0" and !row[index[3]].blank? or !check_fluid.blank?
     if row[index[3]] !="n/a" and row[index[3]] !="0" and !row[index[3]].blank?
    array_of_part_nums = row[index[3]].split(",")    #Converting Part no.'s into array
    if array_of_part_nums.count >=1
     array_of_part_nums.each do |part_no|
       check_part_description = Part.where("part_description_id=?", description).first   #Checking part description if it already exists
        if PartDescription.find(description).description.split.include? 'Fluid'
          part_type = "F"
       else
          part_type = "W"
       end
       check_part_number = Part.where("part_number = ?", part_no).first   #Checking part no. if it already exists
       if check_part_number.blank? and check_part_description.blank?
          smr_wear_part = Part.new({:part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :interval_miles =>row[index[1]], :interval_months =>row[index[2]], :price => row[index[4]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save
          @total_parts<<smr_wear_part.id<<"/"
        elsif !check_part_number.blank? and check_part_description.blank?
          smr_wear_part = Part.new({:parent_id =>check_part_number.id, :part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :interval_miles =>row[index[1]], :interval_months =>row[index[2]], :price => row[index[4]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save
          @total_parts<<smr_wear_part.id<<"/"
        elsif check_part_number.blank? and !check_part_description.blank?
         smr_wear_part = Part.new({:parent_id =>check_part_description.id, :part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :interval_miles =>row[index[1]], :interval_months =>row[index[2]], :price => row[index[4]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save
          @total_parts<<smr_wear_part.id<<"/"
        elsif !check_part_number.blank? and !check_part_description.blank?
          if check_part_number.labour_time.to_s !=row[index[0]] and row[index[0]] !=nil  and !row[index[0]].blank?
            @labour_array<<check_part_number.id<<row[index[0]]<<row[index[4]]<<"/"
          else
            @labour_array<< check_part_number.id<<"/"
          end
        end
        end
       end
      end        
    end      
  end
  
 if index.count == 7
 @total_parts = []
 @labour_array = []
    row[index[3]] = "" if row[index[3]]=="n/a"
    row[index[4]] = "" if row[index[4]]=="n/a"
    row[index[6]] = 0 if row[index[6]]=="n/a"
    check_fluid = PartDescription.find(description).description.split.include? 'Fluid' 
  if row[index[5]]!="n/a"  and row[index[5]] !="0"and row[index[1]] !="0" and row[index[1]]!="n/a"  and row[index[2]]!="n/a" and !row[index[5]].blank? or !check_fluid.blank?
   if row[index[5]]!="n/a"  and row[index[5]] !="0" and !row[index[5]].blank?  and row[index[5]] != "N/APP"
    array_of_part_nums = row[index[5]].split(",") 
    if array_of_part_nums.count >=1   #Converting Part no.'s into array
      array_of_part_nums.each do |part_no|
      check_part_description = Part.where("part_description_id=?", description).first   #Checking part description if it already exists      
       if PartDescription.find(description).description.split.include? 'Fluid'
          part_type = "F"
      else
         part_type = "S"
      end
       check_part_number = Part.where("part_number = ?", part_no).first   #Checking part no. if it already exists
       if check_part_number.blank? and check_part_description.blank?
          smr_wear_part = Part.new({:part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :interval_miles =>row[index[1]], :interval_months =>row[index[2]],
             :ll_interval_miles =>row[index[3]], :ll_interval_months =>row[index[4]], :price => row[index[6]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save!
          @total_parts<<smr_wear_part.id<<"/"
        elsif !check_part_number.blank? and check_part_description.blank?
          smr_wear_part = Part.new({:parent_id =>check_part_number.id, :part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :interval_miles =>row[index[1]], :interval_months =>row[index[2]],
             :ll_interval_miles =>row[index[3]], :ll_interval_months =>row[index[4]], :price => row[index[6]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save!
          @total_parts<<smr_wear_part.id<<"/"
        elsif check_part_number.blank? and !check_part_description.blank?
         smr_wear_part = Part.new({:parent_id =>check_part_description.id, :part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :interval_miles =>row[index[1]], :interval_months =>row[index[2]],
             :ll_interval_miles =>row[index[3]], :ll_interval_months =>row[index[4]], :price => row[index[6]], :embargo_datetime =>"2012-8-1"})
          smr_wear_part.save!
          @total_parts<<smr_wear_part.id<<"/"
        elsif !check_part_number.blank? and !check_part_description.blank?
          if check_part_number.labour_time.to_s !=row[index[0]] and check_part_number.interval_miles.to_s !=row[index[1]] and row[index[0]] != nil and !row[index[0]].blank?
             smr_wear_part = Part.new({:parent_id =>check_part_description.id, :part_number =>part_no, :part_description_id =>description, :part_type =>part_type, :labour_time =>row[index[0]], :interval_miles =>row[index[1]], :interval_months =>row[index[2]],
             :ll_interval_miles =>row[index[3]], :ll_interval_months =>row[index[4]], :price => row[index[6]], :embargo_datetime =>"2012-8-1"})
             smr_wear_part.save!
             @total_parts<<smr_wear_part.id<<"/"
          else
            @labour_array<<check_part_number.id<<"/"
          end
        end
       end
       end
      end      
  end
 end
 #logger.debug "joe123 #{@errs}"
 return @total_parts, @labour_array
   
 end
 
  def service_part?
    self.part_type== "S"
  end
  
  def calculate_price(part)
    self.manufacturer_parts.collect(&:price).first
  end
  
  def select_part_number(part)
    part.part_numbers.collect(&:part_number).first
  end
  
  def self.search(search)
    if search
      joins(:part_description).where("description  ILIKE ? OR part_number = ?","%#{search}%","#{search}")     
    end
  end

end
