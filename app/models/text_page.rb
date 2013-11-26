class TextPage < ActiveRecord::Base
  attr_accessible :name, :source

  extend FriendlyId
  friendly_id :name, use: :slugged
end
