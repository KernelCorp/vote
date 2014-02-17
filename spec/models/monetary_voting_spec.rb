require 'spec_helper'

describe MonetaryVoting  do
  it 'vote for special claim(insufficient funds)' do
    monetary_voting = votings(:current)
    leader = monetary_voting.lead_phone_number
    middlebrow = users(:middlebrow)
    old_balance = middlebrow.billinfo
    claim = claims(:first)
    assert_raise(Exceptions::PaymentRequiredError) { monetary_voting.vote_for_claim claim, 50000 }
    middlebrow.billinfo.should == old_balance
    leader.should == monetary_voting.lead_phone_number
  end

  it 'vote for special claim(sufficient funds to first)' do
    monetary_voting = votings(:current)
    claim = claims(:first)
    old_balance = claim.participant.billinfo
    monetary_voting.vote_for_claim claim, 3000
    claim.participant.billinfo.should eq(old_balance - 3000)
    monetary_voting.lead_phone_number.should eq(claim.phone.number.bytes.collect { |d| d - 48 })
  end

  it 'vote for special claim(sufficient funds to between last and first)' do
    monetary_voting = votings :current
    claim = claims :first
    old_balance = claim.participant.billinfo
    monetary_voting.vote_for_claim claim, 78
    claim.participant.billinfo.should eq(old_balance - 78)
    monetary_voting.matches_count(claim.phone).should eq(5)
  end

  it 'get lead claim' do
    monetary_voting = votings :current
    leader = monetary_voting.lead_claim
    monetary_voting.claims.each do |c|
      monetary_voting.matches_count(leader.phone.number).should >= monetary_voting.matches_count(c.phone.number)
    end
  end

  it 'validate way_to_complete' do
    voting = MonetaryVoting.new way_to_complete: nil
    voting.organization = users :apple

    voting.valid?
    voting.errors.has_key?(:max_users_count).should_not == true
    voting.errors.has_key?(:budget).should_not == true

    voting.way_to_complete = 'sum'
    voting.valid?
    voting.errors.has_key?(:max_users_count).should_not == true
    voting.errors.has_key?(:budget).should_not == nil

    voting.way_to_complete = 'count_users'
    voting.valid?
    voting.errors.has_key?(:budget).should_not == true
    voting.errors.has_key?(:max_users_count).should_not == nil
  end
end
