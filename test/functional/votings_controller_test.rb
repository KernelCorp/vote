require 'test_helper'

class VotingsControllerTest < ActionController::TestCase
  test 'create voting' do
    # ???
    # sign_in users(:apple)
    # post :create, { name: 'name' }
    # assert_redirected_to users(:apple)
  end

  test 'show voting' do

  end

  test 'index with number' do
    get :index, { :number => '1122230000' }
    votings = assigns(:votings)
    sort = votings[0] == Voting.active.where(:name => 'Get drunk!').first &&
      votings[1] == Voting.active.where(:name => 'Get respectable cat!').first &&
      votings[2] == Voting.active.where(:name => 'Get sober!').first &&
      votings[3] == Voting.active.where(:name => 'test_name').first
    assert sort
  end
end
