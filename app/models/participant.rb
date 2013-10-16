class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo

  has_many :phones

  def role? (role)
    role == :participant
  end

end
