require 'test_helper'

class SMSMailerConfigTest < ActiveSupport::TestCase
  test 'init' do
    assert !SMSMailerConfig::gateway.nil?
    assert !SMSMailerConfig::password.nil?
    assert !SMSMailerConfig::login.nil?
  end
end
