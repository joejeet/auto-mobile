class AddMonthsToServices < ActiveRecord::Migration
  def change
  add_column :services, :months, :integer
  end
end
