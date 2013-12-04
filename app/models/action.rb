class Action < ActiveRecord::Base
  attr_accessible :name, :points

  belongs_to :other_voting, :foreign_key => 'voting_id'

  validates_uniqueness_of :name, scope: [:voting_id]
end
