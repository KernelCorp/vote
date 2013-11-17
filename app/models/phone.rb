class Phone < ActiveRecord::Base
  attr_accessible :number

  belongs_to :participant
  has_many :claims

  serialize :number
  validates :number, length: { is: 10 }, uniqueness: true

  def number
    n = read_attribute :number
    n.bytes.collect { |d| d - 48 } # True for chars "0".."9", in unicode and ascii definitely, but seems it true everywhere else(48 code of "0")
  end

  def number= (n)
    n = n.join if n.is_a? Array
    write_attribute :number, n
  end

  def [] (i)
    if i.class == Fixnum
      number[i].to_i
    else
      super(i)
    end
  end

  # Enumerate through numbers
  def each_with_index
    number.each_with_index { |n, i| yield n, i }
  end
end
