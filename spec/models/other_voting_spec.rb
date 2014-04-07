require 'spec_helper'

describe OtherVoting do
  let(:voting) { votings :other_voting }
  let(:user)   { users :middlebrow }
  before do
    FactoryGirl.create :tw_post, voting: voting, participant: user, url: 'https://twitter.com/Politru_project/status/451559020654886912'
    FactoryGirl.create :strategy, voting: voting
    #FactoryGirl.create :vk_post, voting: voting, participant: user, url: 'http://vk.com/vonagam?w=wall8903551_625'
  end

  it 'complete if necessary' do
    voting.update_attributes! end_date: Date.today
    old_users = voting.participants.dup
    voting.complete_if_necessary!

    :prizes.should == voting.reload.status

    voting.social_posts.each { |p| assert !p.count_points.nil? }
    old_users.each do |user|
      new_user = User.find user
      sum = 0
      voting.social_posts.where(participant_id: user).each { |p| sum += p.count_points }
      new_user.billinfo.should == (user.billinfo + sum).round
    end
  end

  it 'complete if necessary timing' do
    voting.update_attributes! end_date: DateTime.now + 10.minutes
    voting.complete_if_necessary!
    :active.should == voting.reload.status


    voting.update_attributes! end_date: DateTime.now
    voting.complete_if_necessary!
    :prizes.should == voting.reload.status
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
    voting.participants.count.should == voting.population
  end

  it '#social_snapshot' do
    post = voting.social_posts.last
    i = post.states.count

    voting.status = :pending
    voting.social_snapshot
    expect( post.states.count ).to eq(i)

    voting.status = :active
    voting.social_snapshot
    expect( post.states.count ).to eq(i+1)

    expect( post.states.last.voters.count ).to be > 0
  end

end
