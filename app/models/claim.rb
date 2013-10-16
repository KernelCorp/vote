class Claim < ActiveRecord::Base
  belongs_to :participant
  belongs_to :voting
  belongs_to :phone
end
