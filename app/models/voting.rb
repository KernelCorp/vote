class Voting < ActiveRecord::Base

  WAYS = %w(count_users sum date count_points)

  STATUSES = { 0 => :pending, 1 => :active, 2 => :prizes, 3 => :close }

  attr_accessible :name, :start_date, :way_to_complete, :min_count_users,
                  :end_date, :prize, :brand, :prize1, :prize2, :prize3, :status, :description,
                  :custom_head_color, :custom_background, :custom_background_color

  prize_options = { styles: { original: '400x400>', full: "220x265>", thumb: "100x100>" },
                    default_url: "http://placehold.it/220x165",
                    path: ':rails_root/public/system/images/prize/:style/:filename',
                    url: '/system/images/prize/:style/:filename' }

  has_attached_file :prize, prize_options
  has_attached_file :prize1, prize_options
  has_attached_file :prize2, prize_options
  has_attached_file :prize3, prize_options

  has_attached_file :brand,
                    :styles => { :original => "200x70>", :thumb => "50x50>" },
                    :default_url => "http://placehold.it/200x70",
                    :path => ':rails_root/public/system/images/brand/:style/:filename',
                    :url => '/system/images/brand/:style/:filename'

  has_attached_file :custom_background,
                    :path => ':rails_root/public/system/images/custom_background/:filename',
                    :url => '/system/images/custom_background/:filename'

  belongs_to :organization
  has_one :phone, class_name: PhoneNumber, foreign_key: 'voting_id', dependent: :destroy
  has_many :claims, dependent: :destroy

  scope :active, -> { where status: 1, end_timer: nil }
  scope :closed, -> { where status: 2..3 }

  validates :name, :description, :presence => true
  validates :way_to_complete, inclusion: { in: WAYS }
  validates :custom_head_color, :custom_background_color, format: { with: /\A#[0-9a-f]{6}\z/i }, allow_blank: true
  validates :status, exclusion: { in: [:active],
                                  message: :first_confirm_org}, unless: 'organization.is_confirmed?'

  after_create :build_some_phone
  after_create :set_default_status
  after_create :start_date_filter
  after_save :save_for_future

  def status
    STATUSES[read_attribute(:status)]
  end

  def status= (s)
    if s.is_a? Integer
      write_attribute :status, s
    elsif (!!(s =~ /^[-+]?[0-9]+$/)) && ((0..3).find s.to_s.to_i)
      write_attribute :status, s.to_s.to_i
    elsif !STATUSES.key(s.to_sym).nil?
      write_attribute :status, STATUSES.key(s.to_sym)
    end
  end

  # Delegate!
  def lead_phone_number
    phone.lead_phone_number
  end

  def population
    claims.group_by(&:participant_id).size
  end

  def votes_count
    count = 0
    phone.each_with_index { |p, _| count += p.popularity }
    count
  end

  def snapshot
    claims.each { |c| ClaimStatistic.create!(claim_id: c.id, place: determine_place(c.phone)) }
  end

  # What to do every day
  def self.shoot_and_save
    active.all.each do |v|
      v.snapshot
      v.complete_if_necessary!
    end
  end

  def can_vote_for_claim?
    status == :active && start_date < DateTime.now
  end

  def can_register_in_voting?
    status == :active
  end

  def complete!
    update_attribute :status, 2
  end

  def complete_if_necessary!
    if need_complete?
      complete!
      return true
    end
    return false
  end


  protected


  def retrive_position_and_length_to_first (phone_number)
    lengths = []

    phone.each_with_index do |p, i|
      l = p.length_to_first_place_for_number phone_number[i]
      lengths.push({ i: i, l: l }) if (block_given? ? yield(l) : true)
    end
    lengths
  end

  def set_default_status
    self.status ||= '0'
  end

  def build_some_phone
    build_phone
  end

  def save_for_future
    phone.save!
  end

  def start_date_filter
    start_date ||= DateTime.now
  end

end
