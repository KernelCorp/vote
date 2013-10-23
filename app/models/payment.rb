class Payment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :amount, :user
end
