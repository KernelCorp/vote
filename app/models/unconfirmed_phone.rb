class UnconfirmedPhone < ActiveRecord::Base
  attr_accessible :number, :confirmation_code

  belongs_to :participant

  validates :number, presence: true, format: { with: /\A\d{10}\z/ }, :uniqueness => { :scope => :participant_id }

  validate :unconfirmed

  def unconfirmed
    if Phone.where( number: self.number ).any?
      errors.add( :number, 'phone already added by someone' ) 
    end
  end
end