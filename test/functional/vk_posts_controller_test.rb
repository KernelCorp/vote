require 'test_helper'

class VkPostsControllerTest < ActionController::TestCase
  test 'should created by id' do
    sign_in :participant, users(:one_time_pass)
    voting = votings :other_voting
    post :create, {other_voting_id: voting, vk_post: {post_id: '3793114_151'}}
    assert_redirected_to other_voting_path(voting)
  end

  test 'should created by valid url' do
    sign_in :participant, users(:one_time_pass)
    voting = votings :other_voting
    post :create, {other_voting_id: voting, vk_post: {url: 'http://vk.com/id3793114?w=wall3793114_151%2Fall'}}
    assert_redirected_to other_voting_path(voting)
  end
end
