require 'test_helper'

class SocialPostTest < ActiveSupport::TestCase
  test 'vk post valid' do
    post = social_posts :vk

    post.valid?
    assert post.errors.empty?, post.errors.full_messages.join('; ')

    assert post.likes != -1, 'Подсчет лайков не работает'
    assert post.reposts != -1, 'Подсчет репостов не работает'
  end

  test 'tw post valid' do
    post = social_posts :tw

    post.valid?
    assert post.errors.empty?, post.errors.full_messages.join('; ')

    assert post.likes != -1, 'Подсчет лайков не работает'
    assert post.reposts != -1, 'Подсчет репостов не работает'
  end

=begin
  test 'fb post valid' do
    Social::Post::Fb.API = Koala::Facebook::API.new 'CAACEdEose0cBAED58x9Bb27YiZBXghrA2qjiJvn7oIbyZBfbgP6JDMLeSXvKuswqmLqWlKhP9J6gcBp2aOhGOnarxuOVQiifXtYLLHHyFgZAkqUqOQDMpKWnBT8FgBj4PNv99ECqlcqhFQwonMtx2Y5oIA7pZBhUNG8mNel3T02zcXw22cWiJBoykquGhiMEurALlesw9wZDZD'
    
    fb = Social::Post::Fb.create voting: votings(:other_voting), participant: users(:middlebrow), url: 'https://www.facebook.com/artem.mikhalitsin/posts/10202614677104238?stream_ref=1'

    assert fb.valid?

    puts fb.get_origin.to_s
  end
=end
end
