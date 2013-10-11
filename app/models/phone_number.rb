class PhoneNumber < ActiveRecord::Base
  belongs_to :voting

  has_one :one,   :class_name => Position, :foreign_key => 'phone_id'
  has_one :two,   :class_name => Position, :foreign_key => 'phone_id'
  has_one :three, :class_name => Position, :foreign_key => 'phone_id'
  has_one :four,  :class_name => Position, :foreign_key => 'phone_id'
  has_one :five,  :class_name => Position, :foreign_key => 'phone_id'
  has_one :six,   :class_name => Position, :foreign_key => 'phone_id'
  has_one :seven, :class_name => Position, :foreign_key => 'phone_id'
  has_one :eight, :class_name => Position, :foreign_key => 'phone_id'
  has_one :nine,  :class_name => Position, :foreign_key => 'phone_id'
  has_one :ten,   :class_name => Position, :foreign_key => 'phone_id'

  def initialize
    build_one
    build_two
    build_three
    build_four
    build_five
    build_six
    build_seven
    build_eight
    build_nine
    build_ten
  end

  def positions
    [ one, two, three, four, five, six, seven, eight, nine, ten ]
  end

  def [] (i)
    if i.class == Fixnum
      positions[i]
    else
      super(i)
    end
  end

  def each_with_index
    positions.each_with_index do |p, i| yield(p, i) end
  end

  def lead_phone_number
    positions.map do |p|
      p.lead_number_with_votes_count.number
    end
  end
end
