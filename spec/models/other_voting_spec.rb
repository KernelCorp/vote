require 'spec_helper'

describe OtherVoting do
  let(:voting) { votings :other_voting }
  let(:user)   { users :middlebrow }
  before do
    FactoryGirl.create :vk_post, voting: voting, participant: user, url: 'http://vk.com/feed?w=wall-34580489_20875'
    FactoryGirl.create :tw_post, voting: voting, participant: user, url: 'https://twitter.com/alexmak/status/436459004651642881'
  end

  it 'complete if necessary' do
    voting.update_attributes! end_date: Date.today
    old_users = voting.participants.dup
    voting.complete_if_necessary!

    :prizes.should == voting.reload.status

    puts voting.social_posts.count

    voting.social_posts.each { |p| assert !p.points.nil? }
    old_users.each do |user|
      new_user = User.find user
      sum = 0
      voting.social_posts.where(participant_id: user).each { |p| sum += p.points }
      new_user.billinfo.should == (user.billinfo + sum)
    end

  end

  it 'count point for participant' do
    points = voting.participant_points user

    expect( points ).to be >= 0
  end

  it 'get sorting participants' do
    voting.sorted_participants.each do |p|
      expect( p.points ).not_to be_nil
    end
  end

  it 'get population' do
    voting = votings :other_voting
    voting.participants.count.should == voting.population
  end

end
