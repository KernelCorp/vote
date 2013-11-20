require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase

  test 'get rate' do
    assert Currency.rate == 2
  end

  test 'rur to vote' do
    rate = Currency.rate
    sum = 30
    assert_equal Currency.rur_to_vote(sum), sum * rate
  end

  test 'vote to rur' do
    rate = Currency.rate
    sum = 30
    assert_equal Currency.vote_to_rur(sum), sum / rate
  end

end
