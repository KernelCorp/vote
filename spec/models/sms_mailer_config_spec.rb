require 'spec_helper'

describe SMSMailerConfig do
  it 'init' do
    SMSMailerConfig.gateway.nil?.should_not == true
    SMSMailerConfig.password.nil?.should_not == true
    SMSMailerConfig.login.nil?.should_not == true
  end
end
