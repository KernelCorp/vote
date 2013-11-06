class Claim < ActiveRecord::Base
  attr_accessible :voting, :phone

  belongs_to :participant
  belongs_to :voting
  belongs_to :phone

  validates :phone_id, uniqueness: true
end
