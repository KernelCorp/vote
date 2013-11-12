class Payment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :amount, :user_id

  scope :approved, ->{ where is_approved: true}

  def approve!
    unless (user.parent.nil?) || (user.paid)
      user.parent.billinfo += amount * 0.1
      user.paid = 1
      user.save!
      user.parent.save!
    end
    write_attribute :is_approved , 1
    save!
  end

  def approved?
    read_attribute(:is_approved)
  end
end
