require 'test_helper'

class MonetaryVotingTest < ActiveSupport::TestCase
  test 'vote for special claim(insufficient funds)' do
    monetary_voting = votings(:current)
    leader = monetary_voting.lead_phone_number
    middlebrow = users(:middlebrow)
    claim = claims(:first)
    assert_raise(Exceptions::PaymentRequiredError) { monetary_voting.vote_for_claim claim, 50000 }
    assert middlebrow.billinfo == 4000
    assert leader == monetary_voting.lead_phone_number
  end

  test 'vote for special claim(sufficient funds)' do
    monetary_voting = votings(:current)
    claim = claims(:first)
    monetary_voting.vote_for_claim claim, 3000
    assert claim.participant.billinfo == 1000, 'bug with billinfo'
    assert monetary_voting.lead_phone_number == claim.phone.number, 'bug with testing function'
  end
end
