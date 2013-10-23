class AtomVote < ActiveRecord::Base
  attr_accessible :number, :votes_count
  validates :number, :votes_count, :presence => true
  validates :number, :length => 1..1, :inclusion => { :in => 0..9 }

  belongs_to :position

  # Get rate in current voting, through position of course
  def rate
    position.votes.count(:conditions => ['`atom_votes`.`votes_count` > ?', self.votes_count]) + 1
  end

  # Get length(delta votes count) to next(up votes count) rate
  def length_to_next
    if rate == 1
      1
    else
      # (rate - 2) because if rate = 3 means that you index needed 1
      position.sorted_down_votes[rate - 2].votes_count - self.votes_count
    end
  end
end
