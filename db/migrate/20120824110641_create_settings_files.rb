class CreateSettingsFiles < ActiveRecord::Migration
  def change
    create_table :settings_files do |t|
      t.string :name
      t.integer :company_id
      

      t.timestamps
    end
  end
end
