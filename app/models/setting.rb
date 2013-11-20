class Setting < ActiveRecord::Base
  attr_accessible :key, :value
  self.primary_key = :key
  validates :key, presence: true, uniqueness: true
end
