require 'spec_helper'

describe Social::Post::Vk do
  it 'get likes' do
    vk_post = social_posts :vk
    likes_count = vk_post.count_likes
    2.should == likes_count
  end

  it 'get reposts count' do
    vk_post = social_posts :vk
    likes_count = vk_post.count_reposts
    0.should == likes_count
  end

  it 'try to create with fake post' do
    vk_post = Social::Post::Vk.new participant: users(:middlebrow), voting: votings(:other_voting), post_id: SecureRandom.hex(8)
    vk_post.valid?.should_not be_true
    assert_includes vk_post.errors[:post_id], I18n.t('activerecord.errors.models.vk_post.post.not_exist')
  end

  it "get post's text" do
    post = social_posts :vk
    post.text.should_not be_blank
  end

  it 'Post with url http://vk.com/id3793114?w=wall3793114_156%2Fall should be exist' do
    url = 'http://vk.com/id3793114?w=wall3793114_156%2Fall'
    post = Social::Post::Vk.new post_id: Social::Post::Vk.url_to_id(url)
    post.get_post_from_vk.should_not be_nil
  end

  it 'Post with url https://vk.com/lentaru?w=wall-29534144_1124690' do
    url = 'https://vk.com/lentaru?w=wall-29534144_1124690'
    post = Social::Post::Vk.new post_id: Social::Post::Vk.url_to_id(url)
    post.get_post_from_vk.should_not be_nil
  end

  it 'set post id before validation' do
    url = 'http://vk.com/id3793114?w=wall3793114_156%2Fall'
    post = Social::Post::Vk.create url: Social::Post::Vk.url_to_id(url)
    '3793114_156'.should == post.post_id
  end
end
