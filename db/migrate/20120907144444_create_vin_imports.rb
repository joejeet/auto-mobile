class CreateVinImports < ActiveRecord::Migration
  def change
    create_table :vin_imports do |t|
      t.string :vin
      t.string :vrm
      t.date :reg_date
      t.string :smr_code
      t.string :country
      t.string :make_code
      t.string :model
      t.integer :engine_cc
      t.integer :power_ps
      t.string :body_style
      t.integer :doors
      t.string :fuel_type
      t.integer :cylinders
      t.string :transmission
      t.integer :number_of_gears
      t.string :driven_wheels
      t.integer :model_year
      t.string :status
      t.string :smr_profile
      t.string :trim
      t.string :honda_desc

      t.timestamps
    end
  end
end
