class ProfilePart < ActiveRecord::Base
  belongs_to :part
  belongs_to :service_plan
  has_one :part_description, :through => :part

  #before_validation :hack

  attr_accessible :part_id, :price, :labour_time, :part_attributes, :part_description, :interval_miles, :interval_months, :ll_interval_miles, :ll_interval_months

  #validates :interval_miles, :numericality => { :only_integer => true }, :presence => true, :inclusion => { :in => 5000..30000, :message => " %{value} miles is not between 5K and 30K miles" }
  #validates :ll_interval_miles, :numericality => { :only_integer => true }, :allow_nil => true, :inclusion => { :in => 5000..30000, :allow_nil => true }
  #validates :ll_interval_miles, :ll_interval_months, :presence => true, :if => :service_part?
  validates :labour_time, :presence => true

  accepts_nested_attributes_for(:part)
 # def service_part?
   # part_type == "S"
  #end

  def hack
    self.price = 200
  end
end
