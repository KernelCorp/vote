module RobokassaConfig
  mattr_accessor :login, :secret_first, :secret_second

  def self.setup
    yield RobokassaConfig
  end
end
