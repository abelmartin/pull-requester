class Repository < ActiveRecord::Base
  belongs_to :user
  belongs_to :build_service
  has_many :pull_request

  attr_accessor :open_reqs, :assignees, :comment_count

  validates :gh_id, presence: true
  validates :name, presence: true
  validates :owner, presence: true
  validates :user, presence: true
end
