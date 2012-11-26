class Tyre < ActiveRecord::Base
  attr_accessible :part_number, :manufacturer, :description, :tyre_type, :vehicle_type, :width, :profile, :construction, :diameter, :speed_rating, :season, :ef_rating, :wet_rating, :noise_rating, :price, :file_date, :supplier, :status
end
