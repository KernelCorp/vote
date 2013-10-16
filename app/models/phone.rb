class Phone < ActiveRecord::Base
  belongs_to :participant
  attr_accessible :number
end
