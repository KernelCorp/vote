class Social::Post::Fb < Social::Post::Base
  cattr_accessor :FB, instance_accessor: false do
    access = ActiveRecord::Base.connection.table_exists?('settings') &&
      Setting.where( key: 'FacebookAccess' ).first.try(:value)

    if access.blank?
      { api: Koala::Facebook::API.new( nil ), expires: 0 }
    else
      access = JSON.parse access
      {
        api: Koala::Facebook::API.new(access['access_token']),
        expires: access['expires']
      }
    end
  end

  def self.update_api_token( short_token )
    token_info = Vote::Application.config.social[:fb][:oauth].exchange_access_token_info short_token
    token_info['expires'] = token_info['expires'].to_i + Time.now.to_i

    Setting['FacebookAccess'].update_attributes! value: token_info.to_json

    @@FB[:api] = Koala::Facebook::API.new token_info['access_token']
    @@FB[:expires] = token_info['expires']
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
    Rails.cache.fetch :fb_snapshot_info, expires_in: 12.hour do
      snapshot_info = nil

      post_ids = post_id.split '_'
      owner_id = post_ids.first
      object_id = post_ids.last
      likes = get_ids(object_id, 'likes', 'id'){ |like| like['id'] }
      reposts = get_ids(object_id, 'sharedposts', 'from.id'){ |repost| repost['from']['id'] }
      users = (likes + reposts).uniq
      users_string = '("'+users.join('","')+'")'

      response = @@FB[:api].fql_multiquery({
        'query1' => "SELECT like_info.like_count, share_info.share_count FROM stream WHERE post_id = \"#{post_id}\"",
        'query2' => "SELECT uid, friend_count, profile_url, sex FROM user WHERE uid IN #{users_string}",
        'query3' => "SELECT uid2 FROM friend WHERE uid1 = #{owner_id} AND uid2 IN #{users_string}",
        'query4' => "SELECT id, is_silhouette FROM profile_pic WHERE id IN #{users_string}"
      })

      data = response['query1'][0]

      snapshot_info = { state: { likes: data['like_info']['like_count'], reposts: data['share_info']['share_count'] }, voters: [] }

      return snapshot_info if users.length == 0

      info    = to_hash response['query2'], 'uid'
      friends = to_hash response['query3'], 'uid2'
      avatars = to_hash response['query4'],  'id'

      users.each do |voter|
        relationship = friends.has_key?(voter) ? 'friend' : 'guest'

        if info.has_key?(voter)
          voter_info = info[voter]
          url = voter_info['profile_url']
          too_friendly = voter_info['friend_count'] != nil && voter_info['friend_count'] > 1000
          gender = voter_info['sex'].nil? ? nil : ( voter_info['sex'] == 'male' ? 1 : 0 )
        else
          url = ''
          too_friendly = false
        end

        has_avatar = !( avatars.has_key?(voter) && avatars[voter]['is_silhouette'] )

        snapshot_info[:voters].push({
          social_id: voter,
          url: url,
          liked: likes.include?(voter),
          reposted: reposts.include?(voter),
          relationship: relationship,
          has_avatar: has_avatar,
          too_friendly: too_friendly,
          gender: gender
        })
      end

      snapshot_info
    end
  rescue => e
    logger.error e.message
    snapshot_info
  end

  protected

  def get_ids( object_id, method, fields, &block )
    result = []
    data = @@FB[:api].get_connections object_id, method, { limit: 1000, fields: fields }, api_version: 'v2.0'
    while !data.blank?
      data.each do |info|
        result << block.call(info).to_s
      end
      data = data.next_page
    end
    result
  end

  def post_exist?
    !post_id.blank?
  end

  def to_hash( array_of_hashes, key )
    Hash[
      array_of_hashes.map { |hash|
        [ 
          hash.delete(key).to_s,
          hash 
        ] 
      }
    ]
  end
end
