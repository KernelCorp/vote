require 'test_helper'

class MonetaryVotingTest < ActiveSupport::TestCase
  test 'vote for special claim(insufficient funds)' do
    monetary_voting = votings(:current)
    leader = monetary_voting.phone.lead_phone_number
    middlebrow = users(:middlebrow)
    claim = claims(:first)
    assert_raise(ArgumentError) { monetary_voting.vote_for_claim claim, 50000 }
    assert middlebrow.billinfo == 4000
    assert leader == monetary_voting.phone.lead_phone_number
  end

  test 'vote for special claim(sufficient funds)' do
    monetary_voting = votings(:current)
    middlebrow = users(:middlebrow)
    claim = claims(:first)
    monetary_voting.vote_for_claim claim, 3000
    assert middlebrow.billinfo == 1000
    assert monetary_voting.phone.lead_phone_number == claim.phone
  end
end
