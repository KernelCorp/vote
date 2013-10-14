class AtomVote < ActiveRecord::Base
  attr_accessible :number, :votes_count
  validates :number, :votes_count, :presence => true
  validates :number, :length => 1..1, :inclusion => { :in => 0..9 }

  belongs_to :position
end
