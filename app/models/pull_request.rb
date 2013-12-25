class PullRequest < ActiveRecord::Base
  belongs_to :watch
  attr_accessible :created_at, :updated_at
end
