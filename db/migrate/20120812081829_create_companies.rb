class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :Name
      t.string :addressline1
      t.string :addressline2
      t.string :City
      t.string :postcode
      t.string :Telephone
      t.string :Fax

      t.timestamps
    end
  end
end
