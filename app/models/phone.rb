class Phone < ActiveRecord::Base
  belongs_to :participant
  attr_accessible :number
  serialize :number

  validates :number, uniqueness: true

  def number= (v)
    v = v.split(//).map { |c| c.to_i } unless v.is_a? Array
    write_attribute :number, v
  end

  def [] (i)
    if i.class == Fixnum
      number[i]
    else
      super(i)
    end
  end

  def each_with_index
    number.each_with_index { |n, i| yield n, i }
  end
end
