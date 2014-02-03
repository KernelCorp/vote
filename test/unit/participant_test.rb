require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase

  test 'add funds!' do
    participant = users :middlebrow
    old_balacne = participant.billinfo
    participant.add_funds! 10
    assert participant.billinfo == (old_balacne + 10)

    old_balacne = participant.billinfo
    assert_raise (ArgumentError) { participant.add_funds!(-2) }
    assert participant.billinfo == old_balacne
  end


  test 'debit!' do
    participant = users :middlebrow
    old_balacne = participant.billinfo
    participant.debit!(old_balacne / 2)
    assert participant.billinfo == (old_balacne / 2)

    old_balacne = participant.billinfo
    assert_raise (Exceptions::PaymentRequiredError) { participant.debit!(old_balacne * 2) }
    assert participant.billinfo == old_balacne
  end

  test 'generate one time password' do
    participant = users :middlebrow
    participant.generate_one_time_password!
    assert !participant.one_time_password.nil?
  end
end
