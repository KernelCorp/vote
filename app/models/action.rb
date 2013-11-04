class Action < ActiveRecord::Base
  attr_accessible :name, :points
  
  belongs_to :voting

  validates_uniqueness_of :name, scope: [:voting_id]
end
