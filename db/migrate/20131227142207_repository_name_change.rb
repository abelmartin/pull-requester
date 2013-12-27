class RepositoryNameChange < ActiveRecord::Migration
  def change
    rename_table :watches, :repositories
    change_table :repositories do |t|
      t.rename :repo_name, :name
      t.rename :repo_id, :gh_id
      t.rename :repo_owner, :owner
    end
  end
end
