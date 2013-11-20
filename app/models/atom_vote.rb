class AtomVote < ActiveRecord::Base
  attr_accessible :number, :votes_count

  validates :number, :votes_count, :presence => true
  validates :number, :length => 1..1, :inclusion => { :in => 0..9 }

  belongs_to :position

  # Get rate in current voting, through position of course( +1 for 1 place, not 0 place)
  def place
    position.votes.count(:conditions => ['`atom_votes`.`votes_count` > ?', self.votes_count]) + 1
  end

  # Get length(delta votes count) to next(up votes count) rate
  def length_to_next
    return -1 if place == 1
    # (rate - 2) because if rate = 3 means that you index needed 1
    position.sorted_down_votes[place - 2].votes_count - self.votes_count + 1
  end

  def length_to_first
    return -1 if place == 1
    position.lead_number_with_votes_count.votes_count - self.votes_count + 1
  end
end
