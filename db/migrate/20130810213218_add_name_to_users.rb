class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, limit: 63
    add_column :users, :avatar_url, :string, limit: 255
    add_column :users, :github_url, :string, limit: 255
  end
end
