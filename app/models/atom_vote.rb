class AtomVote < ActiveRecord::Base
  attr_accessible :number, :votes_count
  validates :number, :votes_count, :presence => true
  validates :number, :length => 1..1, :inclusion => { :in => 0..9 }

  belongs_to :position

  # Get rate in current voting, through position of course
  def rate
    position.votes.count(:conditions => ['`atom_votes`.`votes_count` > ?', self.votes_count])
  end

  # Get length(delta votes count) to next(up votes count) rate
  def length_to_next
    position.sorted_up_votes[rate + 1].votes_count - self.votes_count
  end
end
