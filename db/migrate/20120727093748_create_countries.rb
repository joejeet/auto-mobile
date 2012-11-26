class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.text :name, :null => false
      t.text :country_code, :null => false
      t.timestamps
    end
  end
end
