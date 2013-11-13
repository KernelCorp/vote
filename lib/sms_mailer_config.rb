class SMSMailerConfig
  class << self
    attr_accessor :gateway, :login, :password
  end
  def self.setup
    yield SMSMailerConfig
  end
end