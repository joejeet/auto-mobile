class CreateServiceParts < ActiveRecord::Migration
  def change
    create_table :service_parts do |t|
      t.integer :service_id
      t.integer :part_id
      t.timestamps
    end
  end
end
