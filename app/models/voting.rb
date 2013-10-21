class Voting < ActiveRecord::Base

  WAYS = %w(count_users, sum, date, count_points)

  STATUSES = { pending: 0, active: 1, close: 2 }


  attr_accessible :name, :start_date, :way_to_complete, :min_count_users, :end_date, :prize, :brand, :status
  has_attached_file :prize,
                    :styles => { :original => "220x265>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"

  has_attached_file :brand,
                    :styles => { :original => "200x70>", :thumb => "50x50>" },
                    :default_url => "/images/:style/missing.png"


  belongs_to :organization
  has_one :phone, :class_name => PhoneNumber, :foreign_key => 'voting_id'

  #validates :way_to_complete, inclusion: { in: WAYS }

  after_create :build_some_phone
  after_save :save_for_future

  def status
    STATUSES.key(read_attribute(:status))
  end

  def status=(s)
    write_attribute(:status, STATUSES[s])
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
    i = 0
    leader.each do |p|
      count += 1 if p == Integer(phone_number[i])
      i += 1
    end
    count
  end

  protected

  def build_some_phone
    build_phone
  end

  def save_for_future
    phone.save!
  end
end
