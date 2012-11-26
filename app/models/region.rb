class Region < ActiveRecord::Base
  attr_accessible :name, :country_id


  belongs_to :country, :class_name => 'Country', :foreign_key => "country_id"

end
