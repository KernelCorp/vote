class Voting < ActiveRecord::Base

  WAYS = %w(count_users sum date count_points)

  STATUSES = { 0 => :pending, 1 => :active, 2 => :prizes, 3 => :close }

  attr_accessible :name, :start_date, :way_to_complete, :min_count_users,
                  :end_date, :prize, :brand, :status, :description,
                  :custom_head_color, :custom_background, :custom_background_color

  prize_options = { styles: { original: "220x265>", thumb: "100x100>" },
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

  scope :active, -> { where status: 1 }
  scope :closed, -> { where ['status between ? and ? or end_timer < ?', 2, 3, DateTime.now] }

  validates :name, :description, :presence => true
  validates :way_to_complete, inclusion: { in: WAYS }
  validates :custom_head_color, :custom_background_color, format: { with: /\A#[0-9a-f]{6}\z/i }, allow_blank: true
  validates :status, exclusion: { in: [:active],
                                  message: :first_confirm_org}, unless: 'organization.is_confirmed?'

  after_create :build_some_phone
  after_create :set_default_status
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

  def start_date
    s = read_attribute :start_date
    return '' if s.nil?
    s.strftime('%d/%m/%Y')
  end

  def end_date
    e = read_attribute :end_date
    return '' if e.nil?
    e.strftime('%d/%m/%Y')
  end

  # Delegate!
  def lead_phone_number
    phone.lead_phone_number
  end

  def positions_and_lengths_to_upper_places_for_phone (phone_number)
    pls = self.retrive_position_and_length_to_first(phone_number) { |l| l != -1 }
    result = []

    pls.sort_by! { |pl| pl[:l] }.length.times do |i|
      count = result.last.nil? ? 0 : result.last.fetch(:l)
      indexs = result.last.nil? ? [] : result.last.fetch(:i).clone
      count += pls[i].fetch(:l)
      indexs << pls[i].fetch(:i)
      result.push({ i: indexs, l: count })
    end
    result.reverse!
  end

  def sorted_phone_numbers_for_participant (participant)
    phones = participant.claims.where(voting_id: self.id).map &:phone
    phones.sort_by { |phone| matches_count(phone) }
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
    leader.each_with_index { |p, i| count += 1 if p == phone_number[i].to_i }
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

  def vote_for_number_in_position (number, position, count)
    n = phone[position].votes.find_by_number(number)
    n.votes_count += count
    n.save!
  end

  def snapshot
    claims.each { |c| ClaimStatistic.create!(claim_id: c.id, place: determine_place(c.phone)) }
  end

  def determine_place (phone)
    phones = []

    all_phones = self.claims.map { |c| c.phone.number }

    pre_phones = all_phones.group_by { |p| matches_count p }
    # Go for each key(sorted big to small), get elements and sort to make first one to be that, which has most number of votes
    pre_phones.keys.sort.reverse.each do |key|
      phones << pre_phones[key].sort_by { |elem| self.phone.votes_count_for_phone_number elem }.reverse
    end

    phones.flatten!

    phone = phone.number if phone.is_a? Phone
    place = phones.index phone
    place.nil? ? 0 : place + 1
  end

  # What to do every day
  def self.shoot_and_save
    active.all.each do |v|
      v.snapshot
      v.complete_if_necessary!
    end
  end

  def can_vote_for_claim?
    status == :active
  end

  def can_register_in_voting?
    status == :active
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
end
