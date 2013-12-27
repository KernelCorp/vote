require 'test_helper'

class OtherVotingTest < ActiveSupport::TestCase
  test 'complete if necessary' do
    voting = votings(:other_voting)
    voting.complete_if_necessary!
    assert_equal voting.reload.status, :prizes
  end
end