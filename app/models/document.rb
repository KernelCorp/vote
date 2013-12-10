class Document < ActiveRecord::Base
  belongs_to :organization

  attr_accessible :attachment, :old

  has_attached_file :attachment

  scope :actual, -> { where(old: false) }
  scope :old, -> { where(old: true) }

  def get_from_fire
    update_attribute :old, 0
  end

  def drop_in_fire
    update_attribute :old, 1
  end
end
