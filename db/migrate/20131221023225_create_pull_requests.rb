class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.references :repository

      t.integer :comments, null: false, default: 0
      t.datetime :last_comment_at, null: true
      t.string :last_comment_by, null: true

      t.integer :commits, null: false, default: 0
      t.datetime :last_commit_at, null: true
      t.string :last_comment_by, null: true

      t.integer :additions, null: false, default: 0
      t.integer :deletions, null: false, default: 0
      t.integer :files_changed, null: false, default: 0
      t.timestamps
    end
  end
end
