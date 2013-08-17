class ChangeOwnerNameToRepoOwner < ActiveRecord::Migration
  def change
    rename_column :watches, :owner_name, :repo_owner
  end
end
