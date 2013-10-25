class Action < ActiveRecord::Base
  belongs_to :voting
  attr_accessible :name, :points

  validates_uniqueness_of :name, scope: [:voting_id]
end
