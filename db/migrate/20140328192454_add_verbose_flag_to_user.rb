class AddVerboseFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :verbose, :boolean, default: false, null: false
  end
end
