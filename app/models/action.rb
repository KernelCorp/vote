class Action < ActiveRecord::Base
  attr_accessible :name, :points

  belongs_to :other_voting, :foreign_key => 'voting_id'

  validates_uniqueness_of :name, scope: [:voting_id]

  def can_do?
    self.other_voting.complete_if_necessary!
    self.other_voting.can_vote_for_claim?
  end
end
