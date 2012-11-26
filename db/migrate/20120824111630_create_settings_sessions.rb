class CreateSettingsSessions < ActiveRecord::Migration
  def change
    create_table :settings_sessions do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
