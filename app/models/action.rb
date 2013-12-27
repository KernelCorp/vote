class Action < ActiveRecord::Base
  attr_accessible :name, :points

  belongs_to :other_voting, :foreign_key => 'voting_id'

  validates_uniqueness_of :name, scope: [:voting_id]

  def can_do?
    other_voting.status == 'active'
  end
end
