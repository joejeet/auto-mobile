class UserType < ActiveRecord::Base
  attr_accessible :user_type_name

  serialize :user_type_name

  has_many :users

  
end
