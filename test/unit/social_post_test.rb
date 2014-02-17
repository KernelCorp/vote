require 'test_helper'

class SocialPostTest < ActiveSupport::TestCase
  test 'vk post valid' do
    post = social_posts :vk

    post.valid?
    assert post.errors.empty?, post.errors.full_messages.join('; ')

    assert post.likes != -1, 'Подсчет лайков не работает'
  end
end
