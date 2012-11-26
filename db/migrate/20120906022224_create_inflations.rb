class CreateInflations < ActiveRecord::Migration
  def change
    create_table :inflations do |t|
      t.decimal :labour_y1
      t.decimal :labour_y2
      t.decimal :labour_y3
      t.decimal :labour_y4
      t.decimal :labour_y5
      t.decimal :labour_above_y5
      t.decimal :oil_y1
      t.decimal :oil_y2
      t.decimal :oil_y3
      t.decimal :oil_y4
      t.decimal :oil_y5
      t.decimal :oil_above_y5
      t.decimal :parts_y1
      t.decimal :parts_y2
      t.decimal :parts_y3
      t.decimal :parts_y4
      t.decimal :parts_y5
      t.decimal :parts_above_y5
      t.decimal :tyres_y1
      t.decimal :tyres_y2
      t.decimal :tyres_y3
      t.decimal :tyres_y4
      t.decimal :tyres_y5
      t.decimal :tyres_above_y5
      t.decimal :fuel_y1
      t.decimal :fuel_y2
      t.decimal :fuel_y3
      t.decimal :fuel_y4
      t.decimal :fuel_y5
      t.decimal :fuel_above_y5
      t.integer :country_id
      t.integer :region_id
      t.integer :settings_session_id
      t.integer :settings_file_id

      t.timestamps
    end
  end
end
