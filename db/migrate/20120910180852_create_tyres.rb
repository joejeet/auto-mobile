class CreateTyres < ActiveRecord::Migration
  def change
    create_table :tyres do |t|
      t.string :part_number, :null => false
      t.string :manufacturer, :null => false
      t.string :description, :null => false
      t.string :tyre_type, :null => false
      t.string :vehicle_type, :null => true
      t.integer :width, :null => false, :length => 3
      t.integer :profile, :null => false, :length => 3
      t.string :construction, :null => false, :length => 1
      t.integer :diameter, :null => false, :length => 2
      t.string :speed_rating, :null => false, :length => 1
      t.string :season, :null => false, :length => 1 #S = Summer, W = Winter
      t.string :ef_rating, :null => true
      t.string :wet_rating, :null => true
      t.string :noise_rating, :null => true
      t.decimal :price, :null => false, :precision => 8, :scale => 2
      t.string :file_date, :null => false
      t.string :supplier, :null => false
      t.string :status, :null => false, :length => 1 #C = Current, D = Discontinued, R = Discontinued - product in Rundown
      
      t.timestamps
    end
  end
end
