class Phone < ActiveRecord::Base
  belongs_to :participant
  attr_accessible :number
  serialize :number

  validates :number, :uniqueness => true

  def [] (i)
    if i.class == Fixnum
      number[i]
    else
      super(i)
    end
  end
end
