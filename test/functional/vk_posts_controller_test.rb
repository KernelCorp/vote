require 'test_helper'

class VkPostsControllerTest < ActionController::TestCase
  test "should create" do
    sign_in :participant, users(:one_time_pass)
    voting = votings :other_voting
    post :create, {other_voting_id: voting, vk_post: {post_id: '3793114_151'}}
    assert_redirected_to other_voting_path(voting)
  end

end
