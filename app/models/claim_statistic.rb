class ClaimStatistic < ActiveRecord::Base
  belongs_to :claim
  attr_accessible :place
end
