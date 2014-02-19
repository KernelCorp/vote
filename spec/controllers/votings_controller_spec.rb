require 'spec_helper'

describe VotingsController do

  before :each do
    back_to_1985 # To present I mean
  end

  it 'index with number' do
    get :index, { :number => '1122230000' }
    votings = assigns(:votings)
    sort = votings[0] == Voting.active.find_by_name('Get drunk!') &&
      votings[1] == Voting.active.find_by_name('Get respectable cat!') &&
      votings[2] == Voting.active.find_by_name('Get sober!') &&
      votings[3] == Voting.active.find_by_name('test_name')
    sort.should_not == nil
  end

  it 'vote for claim to closed voting after end timer' do
    middlebrow = users(:middlebrow)
    sign_in :participant, middlebrow
    old_billinfo = middlebrow.billinfo
    voting = votings(:closed_at_2015_01_01)
    time_travel_to '01/01/2015'.to_datetime + 1.5
    request.env['HTTP_REFERER'] = '/'
    post :update_votes_matrix, points: 100, voting_id: voting.id, phone_id: middlebrow.phones.first.id
    middlebrow.billinfo.should == old_billinfo
    JSON.parse(response.body)['_alert'].should == 'close'
  end

end
