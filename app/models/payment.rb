class Payment < ActiveRecord::Base

  CURRENCIES = %w( WMRM BANKOCEAN2R RapidaOceanSvyaznoyR AlfaBankOceanR Qiwi29OceanR VTB24R )

  belongs_to :user
  attr_accessible :amount, :user_id, :currency, :with_promo, :promo

  validates :currency, inclusion: { in: CURRENCIES }, presence: true
  validates :promo, if: :with_promo?, presence: true, numericality: true

  scope :approved, ->{ where is_approved: true }
  scope :with_promo, ->{ where with_promo: true }

  before_create :default_with_promo

  def approve!
    unless (user.parent.nil?) || (user.paid)
      user.parent.billinfo += amount * 0.1
      user.paid = 1
      user.save!
      user.parent.save!
    end
    write_attribute :is_approved , 1
    save!
  end

  def amount
    a = read_attribute :amount
    BigDecimal.new a * 25 / 3
  end

  def approved?
    read_attribute(:is_approved)
  end

  protected

  def default_with_promo
    with_promo ||= 0
  end

  def with_promo?
    with_promo.nil? && with_promo != 0 && with_promo.class != FlaseClass
  end
end
