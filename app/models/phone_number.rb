class PhoneNumber < ActiveRecord::Base
  belongs_to :voting

  has_many :positions,
    foreign_key: 'phone_id',
    before_add: :stopper,
    before_remove: :stopper,
    dependent: :destroy

  after_create :populate_with_positions
  after_save :save_for_future

  def [] (i)
    if i.class == Fixnum
      positions[i]
    else
      super i
    end
  end

  def each_with_index
    positions.each_with_index { |p, i| yield p, i }
  end

  def lead_phone_number
    positions.map { |p| p.lead_number_with_votes_count.number }
  end

  def votes_count_for_phone_number (phone_number)
    count = 0
    self.each_with_index { |p, i| count += p.votes.find_by_number(phone_number[i]).votes_count  }
    count
  end

  protected

  def stopper (p)
    raise ArgumentError.new "We sorry, we cannot provide that service." if positions.length >= 10
  end

  def populate_with_positions
    (0..9).each { |i| positions.build }
  end

  def save_for_future
    positions.each { |p| p.save! }
  end
end
