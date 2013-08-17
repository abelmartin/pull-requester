class Watch < ActiveRecord::Base
  belongs_to :user

  attr_accessible :repo_id, :repo_name, :repo_owner

  attr_accessor :open_reqs
end
