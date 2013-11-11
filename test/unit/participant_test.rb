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
end
