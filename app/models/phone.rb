class Phone < ActiveRecord::Base
  belongs_to :participant
  attr_accessible :number

  def [] (i)
    if i.class == Fixnum
      number[i]
    else
      super(i)
    end
  end
end
