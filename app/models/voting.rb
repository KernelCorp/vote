class Voting < ActiveRecord::Base

  WAYS = %w(count_users sum date count_points)

  STATUSES = { 0 => :pending, 1 => :active, 2 => :prizes, 3 => :close }


  attr_accessible :name, :start_date, :way_to_complete, :min_count_users, :end_date, :prize, :brand, :status, :description
  has_attached_file :prize,
                    :styles => { :original => "220x265>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"

  has_attached_file :brand,
                    :styles => { :original => "200x70>", :thumb => "50x50>" },
                    :default_url => "/images/:style/missing.png"


  belongs_to :organization
  has_one :phone, :class_name => PhoneNumber, :foreign_key => 'voting_id'
  has_many :claims

  has_many :actions, :dependent => :destroy
  accepts_nested_attributes_for :actions, :allow_destroy => :true

  scope :active, ->{where status: 1}

  validates :way_to_complete, inclusion: { in: WAYS }

  after_create :build_some_phone
  after_create :set_default_status
  after_save :save_for_future

  def status
    STATUSES[read_attribute(:status)]
  end

  def status=(s)
    if s.is_a? Integer
      write_attribute(:status, s)
    elsif (0..3).find(s.to_i)
      write_attribute(:status, s.to_i)
    elsif !STATUSES.key(s.to_sym).nil?
      write_attribute(:status, STATUSES.key(s.to_sym))
    end
  end

  def get_rating_for_phone (phone_number)
    rating = []
    phone_number.each_with_index do |n, i|
      rating.push phone[i].get_rating_for_number(n)
    end
    rating
  end

  def matches_count(phone_number)
    leader = phone.lead_phone_number
    count = 0
    leader.each_with_index do |p, i|
      count += 1 if p == Integer(phone_number[i])
    end
    count
  end

  def population
    claims.size
  end

  def votes_count
    ret = 0
    phone.each_with_index do |p, i|
      ret += p.popularity
    end
    ret
  end

  protected

  def set_default_status
    self.status ||= '0'
  end

  def build_some_phone
    build_phone
  end

  def save_for_future
    phone.save!
  end
end
