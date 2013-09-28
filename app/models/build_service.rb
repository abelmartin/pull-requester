class BuildService < ActiveRecord::Base
  has_many :watches

  attr_accessible :name, :badge_pattern
end
