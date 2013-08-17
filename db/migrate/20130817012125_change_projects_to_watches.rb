class ChangeProjectsToWatches < ActiveRecord::Migration
  def change
    rename_table :projects, :watches
  end
end
