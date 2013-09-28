class AddBuildServicesTable < ActiveRecord::Migration
  def change
    create_table :build_services do |t|
      t.string :name, limit: 127, null: false
      t.string :badge_pattern, limit: 256, null: false
    end
  end
end
