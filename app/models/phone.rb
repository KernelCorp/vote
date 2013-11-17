class Phone < ActiveRecord::Base
  attr_accessible :number

  belongs_to :participant
  has_many :claims

  validates :number, uniqueness: true

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
    number.split('').each_with_index { |n, i| yield n, i }
  end
end
