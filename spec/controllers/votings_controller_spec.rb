#encoding: utf-8
require 'spec_helper'

describe VotingsController, :type => :controller do

  before :each do
    back_to_1985 # To present I mean
  end

  it '#new' do
    sign_in :organization, users(:apple)

    get :new

    expect( response.status ).to eq 200
    
    expect( assigns(:voting) ).not_to eq nil
  end

  context 'with other voting' do
    it '#create' do
      sign_in :organization, users(:apple)
      
      post :create, { "voting"=>{ "type"=>"other_voting", "name"=>"Название", "description"=>"Описание", "custom_background_color"=>"#e7e7e7", "custom_head_color"=>"#2c728d", "how_participate"=>"Как участвовать", "start_date"=>(Time.now + 1.day), "max_users_count"=>"", "way_to_complete"=>"date", "end_date"=>(Time.now + 5.days), "points_limit"=>"0", "social_actions_attributes"=>{ "1392977462632"=>{ "type"=>"Social::Action::Vk", "like_points"=>"1", "repost_points"=>"10", "_destroy"=>"false" } }, "other_actions_attributes"=>{ "1392977466459"=>{ "name"=>"Действие", "points"=>"1", "_destroy"=>"false" } } }, "start_date_hour"=>"5", "end_date_hour"=>"5", "commit"=>"Сохранить и отправить на проверку" }

      answer = JSON.parse response.body

      expect( answer['_success'] ).to eq(true)
    end
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
