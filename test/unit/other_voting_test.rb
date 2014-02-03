require 'test_helper'

class OtherVotingTest < ActiveSupport::TestCase
  test 'complete if necessary' do
    voting = votings(:other_voting)
    voting.update_attributes! end_date: Date.today
    voting.complete_if_necessary!

    assert_equal voting.reload.status, :prizes
    voting.vk_posts.each { |p| assert !p.result.nil? }
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
    actual = voting.sorted_participants

    assert_equal actual.map {|u| u.id}, [users(:new).id, user.id]
    assert       actual.first.points == 10
  end

  test 'get population' do
    voting = votings :other_voting
    assert_equal voting.population, voting.participants.count
  end

end
