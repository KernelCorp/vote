class Voting < ActiveRecord::Base

  WAYS = %w(count_users, sum, date, count_points)

  attr_accessible :name, :start_date, :way_to_complete, :min_count_users, :end_date

  has_attached_file :prize,
                    :styles => { :original => "220x265>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"

  has_attached_file :brand,
                    :styles => { :original => "200x70>", :thumb => "50x50>" },
                    :default_url => "/images/:style/missing.png"


  belongs_to :organization
  has_one :phone, :class_name => PhoneNumber, :foreign_key => 'voting_id'

  validates :way_to_complete, inclusion: { in: WAYS }

  def initialize
    build_phone
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
end
