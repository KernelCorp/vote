class Promo < ActiveRecord::Base
  attr_accessible :amount, :code, :date_end

  has_many :promo_uses, class_name: PromoUses

  validates :code, :date_end, presence: true
  validates :code, uniqueness: true

  def active?
    self.date_end > DateTime.now
  end

end
