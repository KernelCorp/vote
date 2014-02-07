require 'test_helper'

class VkPostTest < ActiveSupport::TestCase
  test 'get likes' do
    vk_post = vk_posts :one
    likes_count = vk_post.count_likes
    assert_equal likes_count, 3
  end

  test 'get reposts count' do
    vk_post = vk_posts :one
    likes_count = vk_post.count_reposts
    assert_equal likes_count, 0
  end

  test 'try to create with fake post' do
    vk_post = VkPost.new participant: users(:middlebrow), voting: votings(:other_voting), post_id: SecureRandom.hex(8)
    assert !vk_post.valid?
    assert_includes vk_post.errors[:post_id], I18n.t('activerecord.errors.models.vk_post.post.not_exist')
  end

  test "get post's text" do
    post = vk_posts :one
    assert !post.text.blank?
  end

  test 'get post on my wall by url' do
    url = "http://vk.com/id3793114?w=wall3793114_156%2Fall"
    post = VkPost.new post_id: VkPost.url_to_id(url)
    assert !post.get_post_from_vk.nil?, "Post with id: #{post.post_id} not exist"
  end

  test 'get post from group by url' do
    url = "https://vk.com/lentaru?w=wall-29534144_1124690"
    post = VkPost.new post_id: VkPost.url_to_id(url)
    assert !post.get_post_from_vk.nil?, "Post with id: #{post.post_id} not exist"
  end
end
