class Claim < ActiveRecord::Base
  belongs_to :participant
  belongs_to :voting
  attr_accessible :phone
end
