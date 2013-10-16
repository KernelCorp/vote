class Voting < ActiveRecord::Base
  attr_accessible :name, :start_date

  belongs_to :organization
  has_one :phone, :class_name => PhoneNumber, :foreign_key => 'voting_id'

  def initialize
    build_phone
  end

  def matches_count phone_number
    leader = phone.lead_phone_number
    count = 0
    i = 0
    leader.each do |p|
      count += 1 if p == Integer(phone_number[i])
      i += 1
    end
    count
  end
end
