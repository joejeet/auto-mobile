class SettingsFile < ActiveRecord::Base
  attr_accessible :company_id, :name, :user_id

  has_many :global_company_settings

  has_many :inflations
end
