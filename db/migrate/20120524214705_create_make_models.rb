class CreateMakeModels < ActiveRecord::Migration
  def change
    create_table :make_models do |t|
      t.integer :manufacturer_id
      t.text :country_code
      t.text :make
      t.text :make_code
      t.text :model
      t.text :model_code
      t.timestamps
    end
  end
end
