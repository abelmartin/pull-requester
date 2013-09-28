class AddBuildServiceIdToWatches < ActiveRecord::Migration
  def change
    add_column :watches, :build_service_id, :integer, null: true
  end
end
