class ClaimStatistic < ActiveRecord::Base
  belongs_to :claim
  attr_accessible :votes_count
end
