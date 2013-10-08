class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo

  def role? (role)
    role == :participant
  end
end
