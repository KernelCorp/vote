require 'test_helper'

class SMSMailerConfigTest < ActiveSupport::TestCase
  test 'init' do
    assert !SMSMailerConfig.gateway.nil?
    assert !SMSMailerConfig.password.nil?
    assert !SMSMailerConfig.login.nil?
  end
  test 'try to send' do
    SMSMailer.send_sms '79134577371', 'hi' if true
    assert true
  end
end
