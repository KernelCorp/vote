class Voting < ActiveRecord::Base
  attr_accessible :name, :start_date

  belongs_to :organization
  has_one :phone, :class_name => PhoneNumber, :foreign_key => 'phone_id'

  def initialize
    build_phone
  end
end
