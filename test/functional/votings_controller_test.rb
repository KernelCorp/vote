require 'test_helper'

class VotingsControllerTest < ActionController::TestCase
  test 'create voting' do
    sign_in users(:apple)
    post :create, {name: 'name'}
    assert_redirected_to users(:apple)
  end

  test 'show voting' do

  end
end
