class Social::Post::Fb < Social::Post
  cattr_accessor :FB, instance_accessor: false do 
    { api: Koala::Facebook::API.new( nil ), expires: 0 }
  end

  def self.update_api_token( short_token )
    token_info = Vote::Application.config.social[:fb][:oauth].exchange_access_token_info short_token
    @@FB[:api] = Koala::Facebook::API.new token_info['access_token']
    @@FB[:expires] = token_info['expires'].to_i + Time.now.to_i
  end


  def self.post_id_from_url( url )
    m = url.scan(/([^\/]+)\/posts\/(\d+)/)[0]

    response = @@FB[:api].fql_query "SELECT id FROM profile WHERE username = \"#{m[0]}\" OR id = \"#{m[0]}\""

    response = @@FB[:api].fql_query "SELECT post_id FROM stream WHERE post_id = \"#{response[0]['id']}_#{m[1]}\""

    response[0]['post_id']
  rescue
    nil
  end

  def snapshot_info
    snapshot_info = nil

    owner_id = post_id.split('_').first

    response = @@FB[:api].fql_multiquery({
      'query1' => "SELECT like_info.like_count, share_info.share_count FROM stream WHERE post_id = \"#{post_id}\"",

      'query2' => "SELECT user_id FROM like WHERE post_id = \"#{post_id}\"",

      'query3' => "SELECT uid, friend_count, profile_url FROM user WHERE uid IN ( SELECT user_id FROM #query2 )",

      'query4' => "SELECT uid2 FROM friend WHERE uid1 = #{owner_id} AND uid2 IN ( SELECT user_id FROM #query2 )",

      'query5' => "SELECT id, is_silhouette FROM profile_pic WHERE id IN ( SELECT user_id FROM #query2 )"
    })

    data = response['query1'][0]

    snapshot_info = { state: { likes: data['like_info']['like_count'], reposts: data['share_info']['share_count'] }, voters: [] }

    return snapshot_info if response['query2'].length == 0

    info    = to_hash response['query3'], 'uid'
    friends = to_hash response['query4'], 'uid2'
    avatars = to_hash response['query5'],  'id'

    response['query2'].each do |user_data|
      voter = user_data['user_id'].to_i

      relationship = friends.has_key?(voter) ? 'friend' : 'guest'

      if info.has_key?(voter)
        url = info[voter]['profile_url']
        too_friendly = info[voter]['friend_count'] != nil && info[voter]['friend_count'] > 1000
      else
        url = ''
        too_friendly = false
      end

      has_avatar = !( avatars.has_key?(voter) && avatars[voter]['is_silhouette'] )

      snapshot_info[:voters].push({
        url: url,
        liked: true,
        reposted: false,
        relationship: relationship,
        has_avatar: has_avatar,
        too_friendly: too_friendly  
      })
    end

    snapshot_info
  rescue
    snapshot_info
  end

  protected

  def post_exist?
    !post_id.blank?
  end

  def to_hash( array_of_hashes, key )
    Hash[
      array_of_hashes.map { |hash|
        [ 
          hash.delete(key).to_i,
          hash 
        ] 
      }
    ]
  end
end
