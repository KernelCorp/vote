class AtomVote < ActiveRecord::Base
  attr_accessible :number, :vote_count
  belongs_to :position
end
