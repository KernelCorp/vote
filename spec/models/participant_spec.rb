require 'spec_helper'

describe Participant do

  it 'add funds!' do
    participant = users :middlebrow
    old_balacne = participant.billinfo
    participant.add_funds! 10
    participant.billinfo.should == (old_balacne + 10)

    old_balacne = participant.billinfo
    assert_raise (ArgumentError) { participant.add_funds!(-2) }
    participant.billinfo.should == old_balacne
  end


  it 'debit!' do
    participant = users :middlebrow
    old_balacne = participant.billinfo
    participant.debit!(old_balacne / 2)
    participant.billinfo.should == (old_balacne / 2)

    old_balacne = participant.billinfo
    assert_raise (Exceptions::PaymentRequiredError) { participant.debit!(old_balacne * 2) }
    participant.billinfo.should == old_balacne
  end

  it 'generate one time password' do
    participant = users :middlebrow
    participant.generate_one_time_password!
    participant.one_time_password.nil?.should_not == true
  end
end
