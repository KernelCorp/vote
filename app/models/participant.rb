class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo

  has_many :phones
  has_many :claims

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
end
