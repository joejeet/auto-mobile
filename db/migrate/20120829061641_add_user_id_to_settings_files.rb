class AddUserIdToSettingsFiles < ActiveRecord::Migration
  def change
    add_column :settings_files, :user_id, :integer
  end
end
