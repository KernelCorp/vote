class SMSMailerConfig
  class << self
    attr_accessor :gateway, :login, :password
    def setup
      yield self
    end
  end
end