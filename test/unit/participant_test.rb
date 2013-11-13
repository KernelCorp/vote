require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
 test 'debit!' do
   participant = users :middlebrow
   old_balacne = participant.billinfo
   participant.debit!(old_balacne / 2)
   assert participant.billinfo == (old_balacne / 2)

   old_balacne = participant.billinfo
   assert_raise (Exceptions::PaymentRequiredError) {participant.debit!(old_balacne * 2)}
   assert participant.billinfo == old_balacne
 end

  test 'genrate one time password' do
    participant = users :middlebrow
    participant.genrate_one_time_password!
    assert !participant.one_time_password.nil?
  end
end
