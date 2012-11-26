class CreatePartNumbers < ActiveRecord::Migration
  def change
    create_table :part_numbers do |t|
      t.references  :part, :null => false
      t.text :part_number, :null => false
      t.timestamps
    end
  end
end
