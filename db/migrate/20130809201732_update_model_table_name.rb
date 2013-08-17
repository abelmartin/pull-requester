class UpdateModelTableName < ActiveRecord::Migration
  def up
    rename_table :models, :users
  end

  def down
    rename_table :users, :models
  end
end
