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
    sort = votings[0] == Voting.active.find_by_name('Get drunk!') &&
      votings[1] == Voting.active.find_by_name('Get respectable cat!') &&
      votings[2] == Voting.active.find_by_name('Get sober!') &&
      votings[3] == Voting.active.find_by_name('test_name')
    assert sort
  end
end
