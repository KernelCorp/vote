class Phone < ActiveRecord::Base
  belongs_to :participant
  attr_accessible :number
  serialize :number

  validates :number, :uniqueness => true

  def to_a
    number.split //
  end


  def [] (i)
    if i.class == Fixnum
      number[i]
    else
      super(i)
    end
  end
end
