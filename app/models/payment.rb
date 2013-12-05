#encoding: UTF-8

class Payment < ActiveRecord::Base

  CURRENCIES = %w( WMRM BANKOCEAN2R RapidaOceanSvyaznoyR AlfaBankOceanR Qiwi29OceanR VTB24R )

  belongs_to :user
  attr_accessible :amount, :user_id, :currency, :with_promo, :promo, :user

  validates :currency, inclusion: { in: CURRENCIES }, presence: true
  validates :promo, if: :with_promo?, presence: true, numericality: true

  scope :approved, ->{ where is_approved: true }
  scope :with_promo, ->{ where with_promo: true }

  before_create :default_with_promo

  def approve!
    user.billinfo += self.amount + promo_bonus + first_paid_bonus
    unless (user.parent.nil?) || (user.paid)
      user.parent.billinfo += amount * 0.1
      user.parent.save!
    end
    user.paid = 1
    user.save!
    write_attribute :is_approved , 1
    save!
  end

  def amount
    Currency.rur_to_vote read_attribute(:amount)
  end

  def approved?
    read_attribute :is_approved
  end

  def when_created
    read_attribute(:created_at).strftime('%d/%m/%Y')
  end

  def is_approved
    I18n.t "participant.payment.status.#{read_attribute(:is_approved)}"
  end

  def human_currency
    case currency
    when 'WMRM'                 then 'Web Money'
    when 'BANKOCEAN2R'          then 'Bank card'
    when 'RapidaOceanSvyaznoyR' then 'Связной'
    when 'AlfaBankOceanR'       then 'Alfabank'
    when 'Qiwi290OceanR'        then 'Qiwi'
    when 'VTB24R'               then 'ВТБ24'
    end
  end

  def promo_usable?
    promo = Promo.find_by_code self.promo
    !promo.nil? && promo.active? &&
      PromoUses.joins(:promo).where(participant_id: user.id, promos: { code: self.promo }).first.nil?
  end

  protected

  def promo_bonus
    promo = Promo.find_by_code self.promo
    if !promo.nil? && promo_usable?
      PromoUses.create! do |pu|
        pu.participant = user
        pu.promo = promo
      end
      promo.amount
    else
      0
    end
  end

  def first_paid_bonus
    if user.paid?
      0
    else
      amount * FirstBonus.value / 100 unless user.paid?
    end
  end

  def default_with_promo
    with_promo ||= 0
  end

  def with_promo?
    with_promo.nil? && with_promo != 0 && with_promo.class != FlaseClass
  end
end
