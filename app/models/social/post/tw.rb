class Social::Post::Tw < Social::Post

  def self.post_id_from_url( url )
    id = url.scan /status\/(\d+)/

    id.empty? ? nil : id[0][0]
  end

  def snapshot_info
    snapshot_info = nil

    tweet = api_call 'statuses/show', trim_user: true, include_entities: false, id: post_id

    snapshot_info = { state: { likes: tweet['favorite_count'], reposts: tweet['retweet_count'] }, voters: [] }

    return snapshot_info if snapshot_info[:state][:reposts] == 0

    retweeters = cursored_ids_call 'statuses/retweeters/ids', id: post_id

    user_id = tweet['user']['id_str']

    friends =   cursored_ids_call(   'friends/ids', user_id: user_id, count: 5000 ).flatten
    followers = cursored_ids_call( 'followers/ids', user_id: user_id, count: 5000 ).flatten

    retweeters.each do |voters|
      api_call( 'users/lookup', user_id: voters.join(','), include_entities: false ).each do |voter|
        voter_id = voter['id']

        if friends.include? voter_id
          relationship = 'friend'
        elsif followers.include? voter_id
          relationship = 'follower'
        else
          relationship = 'guest'
        end

        snapshot_info[:voters].push({
          url: "https://twitter.com/#{voter['screen_name']}",
          liked: false,
          reposted: true,
          relationship: relationship,
          has_avatar: !voter['default_profile_image'],
          too_friendly: voter['friends_count'] > 1000
        })
      end
    end

    snapshot_info
  rescue => e
    logger.error e.message
    snapshot_info
  end

  protected

  def post_exist?
    tweet = api_call 'statuses/show', trim_user: true, include_entities: false, id: post_id

    !tweet.nil? && tweet.has_key?('text')
  end

  def cursored_ids_call( method, args_hash )
    returned = []
    args_hash[:cursor] = -1
  
    while args_hash[:cursor] != 0
      response = api_call method, args_hash
      returned.push response['ids']
      args_hash[:cursor] = response['next_cursor']
    end

    return returned
  end

  def api_call( method, args_hash )
    if args_hash.delete :post
      RestClient::Resource
      .new("https://api.twitter.com/1.1/#{method}.json")
      .post( args_hash.merge({ 'Authorization' => "Bearer #{Vote::Application.config.social[:tw][:token]}" }) ) do |response|
        return JSON.parse response.body
      end
    else
      RestClient::Resource
      .new("https://api.twitter.com/1.1/#{method}.json?#{args_hash.to_query}")
      .get( { 'Authorization' => "Bearer #{Vote::Application.config.social[:tw][:token]}" } ) do |response|
        return JSON.parse response.body
      end
    end
  end
end

# # https://dev.twitter.com/docs/api/1.1/get/statuses/show/%3Aid
# # https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
# https://dev.twitter.com/docs/api/1.1/get/users/lookup
# # https://dev.twitter.com/docs/api/1.1/get/followers/ids
# # https://dev.twitter.com/docs/api/1.1/get/friends/ids
