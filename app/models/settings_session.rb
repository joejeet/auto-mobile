class SettingsSession < ActiveRecord::Base
  attr_accessible :user_id


  has_one :global_company_setting

  has_one :inflation
end
