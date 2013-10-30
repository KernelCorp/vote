class Document < ActiveRecord::Base
  belongs_to :organization

  attr_accessible :attachment

  has_attached_file :attachment
end
