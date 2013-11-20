class UnconfirmedPhone < ActiveRecord::Base
  attr_accessible :number, :confirmation_code

  belongs_to :participant

  validates :number, length: { is: 10 }, uniqueness: true

  validate :unconfirmed

  def unconfirmed
    if Phone.where( number: self.number ).any?
      errors.add( :number, 'phone already added by someone' ) 
    end
  end
end