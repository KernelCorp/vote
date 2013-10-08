class Admin < User

  def role? (role)
    role == :admin
  end
end
