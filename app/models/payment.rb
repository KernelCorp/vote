class Payment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :amount, :user

  scope :approved, ->{ where is_approved: true}

  def approve!
    write_attribute :is_approved , 1
    save!
  end

  def approved?
    read_attribute(:is_approved)
  end
end
