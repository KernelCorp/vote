class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo

  has_many :phones
  has_many :claims

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

  def self.find_first_by_auth_conditions (warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where([
        "lower(login) = :value OR lower(email) = :value OR lower(phone) = :value",
        { :value => login.downcase }
      ]).first
    else
      where(conditions).first
    end
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
