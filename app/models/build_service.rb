class BuildService < ActiveRecord::Base
  has_many :repositories

  attr_accessible :name, :badge_pattern
end
