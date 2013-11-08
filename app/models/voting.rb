class Voting < ActiveRecord::Base

  WAYS = %w(count_users sum date count_points)

  STATUSES = { 0 => :pending, 1 => :active, 2 => :prizes, 3 => :close }


  attr_accessible :name, :start_date, :way_to_complete, :min_count_users, :end_date, :prize, :brand, :status, :description
  has_attached_file :prize,
                    :styles => { :original => "220x265>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png",
                    :path => ':rails_root/public/system/images/prize/:style/:filename',
                    :url => '/system/images/prize/:style/:filename'

  has_attached_file :brand,
                    :styles => { :original => "200x70>", :thumb => "50x50>" },
                    :default_url => "/images/:style/missing.png",
                    :path => ':rails_root/public/system/images/brand/:style/:filename',
                    :url => '/system/images/brand/:style/:filename'

  belongs_to :organization
  has_one :phone, :class_name => PhoneNumber, :foreign_key => 'voting_id'
  has_many :claims

  scope :active, ->{ where status: 1 }

  validates :way_to_complete, inclusion: { in: WAYS }

  after_create :build_some_phone
  after_create :set_default_status
  after_save :save_for_future

  def status
    STATUSES[read_attribute(:status)]
  end

  def status= (s)
    if s.is_a? Integer
      write_attribute :status, s
    elsif (0..3).find s.to_i
      write_attribute :status, s.to_s.to_i
    elsif !STATUSES.key(s.to_sym).nil?
      write_attribute :status, STATUSES.key(s.to_sym)
    end
  end

  def lengths_to_upper_places_for_phone (phone_number)
    lengths = []
    result = []
    phone.each_with_index do |p, i|
      l = p.length_to_first_place_for_number phone_number[i]
      lengths.push l unless l == -1
    end
    lengths.sort!.length.times do |i|
      count = 0
      loop do
        count += lengths[i]
        break unless i > 0
        i -= 1
      end
      result.push count
    end
    result.reverse!
  end

  # Sorted down phones for participant
  def sorted_phone_numbers_for_participant (participant)
    phones = participant.claims.where(voting_id: self.id).map &:phone
    phones.sort { |f, s| matches_count(f) < matches_count(s) ? 1 : -1 }
  end

  def ratings_for_phones (phone_numbers)
    ratings = []
    phone_numbers.each_with_index { |pn, i| ratings.push rating_for_phone(pn) }
    ratings
  end

  def rating_for_phone (phone_number)
    rating = []
    phone_number.each_with_index { |n, i| rating.push phone[i].place_for_number(n) }
    rating
  end

  def matches_count (phone_number)
    leader = phone.lead_phone_number
    count = 0
    leader.each_with_index { |p, i| count += 1 if p == phone_number[i] }
    count
  end

  def population
    claims.group_by(&:participant_id).size
  end

  def votes_count
    count = 0
    phone.each_with_index { |p, _| count += p.popularity }
    count
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
