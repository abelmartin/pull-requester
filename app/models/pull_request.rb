class PullRequest < ActiveRecord::Base
  belongs_to :repository
end
