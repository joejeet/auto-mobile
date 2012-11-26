class ChangeDataTypeMakeModel < ActiveRecord::Migration
  def up
    remove_column :make_models, :make_code
    remove_column :make_models, :model
    remove_column :make_models, :model_code
    add_column :make_models, :make_code, :string
    add_column :make_models, :model, :string
    add_column :make_models, :model_code, :string
  end

  def down
  end
end
