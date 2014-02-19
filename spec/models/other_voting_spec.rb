require 'spec_helper'

describe OtherVoting do
  it 'complete if necessary' do
    voting = votings(:other_voting)
    voting.update_attributes! end_date: Date.today
    old_users = voting.participants.dup
    voting.complete_if_necessary!

    :prizes.should == voting.reload.status
    voting.social_posts.each { |p| assert !p.result.nil? }
    old_users.each do |user|
      new_user = User.find user
      sum = 0
      voting.social_posts.where(participant_id: user).each { |p| sum += p.result}
      new_user.billinfo.should == (user.billinfo + sum)
    end

  end

  it 'count point for participant' do
    voting = votings :other_voting
    user   = users :middlebrow
    points = voting.count_point_for user

    2.should == points
  end

  it 'get sorting participants' do
    voting = votings :other_voting
    user   = users :middlebrow
    actual = voting.sorted_participants

    assert_equal actual.map {|u| u.id}, [users(:new).id, user.id]
    actual.first.points.should == 10
  end

  it 'get population' do
    voting = votings :other_voting
    voting.participants.count.should == voting.population
  end

end
