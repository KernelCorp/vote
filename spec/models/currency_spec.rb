require 'spec_helper'

describe "Currency" do

  it 'get rate' do
    Currency.rate.should == 2
  end

  it 'rur to vote' do
    rate = Currency.rate
    sum = 30
    (sum * rate).should == Currency.rur_to_vote(sum)
  end

  it 'vote to rur' do
    rate = Currency.rate
    sum = 30
    (sum / rate).should == Currency.vote_to_rur(sum)
  end

end
