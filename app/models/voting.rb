class Voting < ActiveRecord::Base
  attr_accessible :name, :start_date

  belongs_to :organization
  has_one :phone, :class_name => PhoneNumber, :foreign_key => 'voting_id'

  after_create :build_some_phone
  after_save :save_for_future

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
