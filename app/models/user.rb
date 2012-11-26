class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, 
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me, :company_id, :active_status, :is_admin, :user_type_id
  # attr_accessible :title, :body

  


  belongs_to :user_type, :class_name => 'UserType', :foreign_key => "user_type_id"

  belongs_to :company, :class_name => 'Company', :foreign_key => "company_id"

  validates :company_id, :presence => true

  validates :user_type_id, :presence => true

end

