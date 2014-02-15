class Repository < ActiveRecord::Base
  belongs_to :user
  belongs_to :build_service
  has_many :pull_request

  attr_accessible :gh_id, :name, :owner, :build_service_id

  attr_accessor :open_reqs
end
