class Social::Post::Vk < Social::Post

  def self.post_id_from_url( url )
    id = url.scan /wall(-?\d+_\d+)/

    id.empty? ? nil : id[0][0]
  end

  def snapshot_info
    ids = post_id.split '_'
    owner_is_user = /^[^\-]/.match( ids[0] ) != nil

    if owner_is_user
      friends   = items_api_call 'friends.get', user_id: ids[0]
      followers = items_api_call 'users.getFollowers', user_id: ids[0], count: 1000
    end

    likes   = items_api_call 'likes.getList', type: 'post', owner_id: ids[0], item_id: ids[1], count: 1000, post: true
    reposts = items_api_call 'likes.getList', type: 'post', owner_id: ids[0], item_id: ids[1], count: 1000, filter: 'copies'

    snapshot_info = { state: { likes: likes.size, reposts: reposts.size }, voters: [] }

    return snapshot_info if snapshot_info[:state][:likes] == 0

    avatars = Hash[
      api_call( 'users.get', fields: 'photo_max', user_ids: likes.join(','), post: true ).map { |user| 
        [user['id'], user['photo_max'] != 'http://vk.com/images/camera_b.gif'] 
      }
    ]

    likes.each do |voter|
      relationship = 'guest'

      if owner_is_user
        if friends.include? voter
          relationship = 'friend'
        elsif followers.include? voter
          relationship = 'follower'
        end
      end

      too_friendly = items_api_call( 'friends.get', user_id: voter ).size > 1000

      snapshot_info[:voters].push({
        url: "http://vk.com/id#{voter}",
        liked: true,
        reposted: reposts.include?(voter),
        relationship: relationship,
        has_avatar: avatars[voter],
        too_friendly: too_friendly  
      })
    end

    return snapshot_info
  end

  protected

  def post_exist?
    ! api_call( 'wall.getById', posts: post_id, copy_history_depth: 0 ).empty?
  end

  def api_call( method, args_hash )
    args_hash[:v] = 5.16

    if args_hash.delete :post
      req = Net::HTTP.post_form URI.parse("http://api.vk.com/method/#{method}"), args_hash
    else
      req = Net::HTTP.get_response URI.parse "http://api.vk.com/method/#{method}?#{args_hash.to_query}"
    end

    return JSON.parse( req.body )['response']
  end

  def items_api_call( method, args_hash )
    result = api_call( method, args_hash )
    !result.nil? && result.has_key?('items') ? result['items'] : []
  end

end
