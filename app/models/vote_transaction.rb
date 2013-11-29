class VoteTransaction < ActiveRecord::Base
  belongs_to :claim
  belongs_to :participant

  attr_accessible :amount
end
