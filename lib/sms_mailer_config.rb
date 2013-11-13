module SMSMailerConfig
  mattr_accessor :gateway, :login, :password, :sender

  def self.setup
    yield SMSMailerConfig
  end

end