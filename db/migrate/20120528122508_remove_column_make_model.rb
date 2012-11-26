class RemoveColumnMakeModel < ActiveRecord::Migration
  def up
    remove_column :make_models, :make
  end

  def down
  end
end
