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
    positions.map do |p|
      p.lead_number_with_votes_count.number
    end
  end

  protected

  def stopper (p)
    if positions.length >= 10
      raise ArgumentError.new "We sorry, we cannot provide that service."
    end
  end

  def populate_with_positions
    (0..9).each do |i|
      positions.build
    end
  end

  def save_for_future
    positions.each do |p|
      p.save!
    end
  end
end
