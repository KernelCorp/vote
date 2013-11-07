class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo, :age, :gender, :city

  has_many :phones, dependent: :destroy
  has_many :claims, dependent: :destroy

  after_create :create_phone

  def participates?(voting)
    !self.claims.where(voting_id: voting).empty?
  end

  def fullname
    "#{firstname} #{secondname}"
  end

  def role? (role)
    role == :participant
  end

  def debit!(sum)
    if billinfo >= sum
      self.billinfo = billinfo - sum
      self.save!
    else
      raise StandardError::ArgumentError.new('Insufficient funds')
    end
  end

  protected

  def create_phone
    self.phones.create! number: self.phone unless self.phone.nil?
  end

end
