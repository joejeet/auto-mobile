class Company < ActiveRecord::Base
  attr_accessible :City, :Name, :Telephone, :addressline1, :addressline2, :postcode, :active_status

  validates_presence_of :Name, :addressline1, :City, :Telephone
  validates_uniqueness_of :Name, :on => :create
  

  has_many :users

  has_one :global_company_setting

  
end
