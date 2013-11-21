require 'test_helper'

class MonetaryVotingTest < ActiveSupport::TestCase
  test 'vote for special claim(insufficient funds)' do
    monetary_voting = votings(:current)
    leader = monetary_voting.lead_phone_number
    middlebrow = users(:middlebrow)
    old_balance = middlebrow.billinfo
    claim = claims(:first)
    assert_raise(Exceptions::PaymentRequiredError) { monetary_voting.vote_for_claim claim, 50000 }
    assert middlebrow.billinfo == old_balance
    assert leader == monetary_voting.lead_phone_number
  end

  test 'vote for special claim(sufficient funds to first)' do
    monetary_voting = votings(:current)
    claim = claims(:first)
    old_balance = claim.participant.billinfo
    monetary_voting.vote_for_claim claim, 3000
    assert claim.participant.billinfo == old_balance - 3000 * Currency.rur_to_vote(monetary_voting.cost), 'bug with billinfo'
    assert monetary_voting.lead_phone_number == claim.phone.number.bytes.collect { |d| d - 48 }, 'bug with testing function'
  end

  test 'vote for special claim(sufficient funds to between last and first)' do
    monetary_voting = votings :current
    claim = claims :first
    old_balance = claim.participant.billinfo
    monetary_voting.vote_for_claim claim, 78
    assert claim.participant.billinfo == old_balance - 78 * Currency.rur_to_vote(monetary_voting.cost), 'billinfo wrong update'
    assert monetary_voting.matches_count(claim.phone) == 5, 'wrong matches count'
  end
end
