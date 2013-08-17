class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_login, :string, limit: 64
  end
end
