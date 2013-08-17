class AddUidAndProviderToUser < ActiveRecord::Migration
  def change
    add_column :users, :omni_uid, :string, limit: 255
    add_column :users, :omni_provider, :string, limit: 63
  end
end
