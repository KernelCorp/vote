require 'test_helper'

class OtherVotingTest < ActiveSupport::TestCase
  test 'complete if necessary' do
    voting = votings(:other_voting)
    voting.complete_if_necessary!
    assert_equal voting.reload.status, :prizes
  end

  test 'count point for participant' do
    voting = votings :other_voting
    user   = users :middlebrow
    points = voting.count_point_for user
    assert_equal points, 3
  end

  test 'get sorting participants' do
    voting = votings :other_voting
    user   = users :middlebrow
    assert_equal voting.sorted_participants, [user]
  end
end