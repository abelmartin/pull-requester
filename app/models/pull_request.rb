class PullRequest < ActiveRecord::Base
  belongs_to :repository
  attr_accessible :created_at, :updated_at
end
