class PromoUses < ActiveRecord::Base
  belongs_to :participant
  belongs_to :promo

  validates :promo, :participant, presence: true
end
