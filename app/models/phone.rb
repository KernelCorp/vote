class Phone < ActiveRecord::Base
  attr_accessible :number

  belongs_to :participant
  has_many :claims

  validates :number, length: { is: 10 }, uniqueness: true

  def number
    read_attribute :number
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
    number.bytes.collect { |d| d - 48 }.each_with_index { |n, i| yield n, i }
  end
end
