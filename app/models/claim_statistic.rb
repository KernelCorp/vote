class ClaimStatistic < ActiveRecord::Base
  belongs_to :claim
  attr_accessible :claim_id, :place
end
