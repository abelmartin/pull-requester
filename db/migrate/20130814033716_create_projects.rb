class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :repo_name, limit: 255, null: false
      t.integer :repo_id, null: false
      t.string :owner_name, limit: 255, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end

