class CreatePartDescriptions < ActiveRecord::Migration
  def change
    create_table :part_descriptions do |t|
      t.references  :part
      t.text :description
      t.text :spread_miles
      t.text :spread_months
      t.timestamps
    end
  end
end
