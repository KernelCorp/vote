class Social::Post::Ok < Social::Post
  before_validation :add_omniauth_to_post_id, on: :create

  
  def self.post_id_from_url( url )
    m = url.scan /\/(topic|statuses)\/(\d+)/ 

    return nil if m.empty?

    [ ( (m[0][0] == 'topic') ? 'GROUP_TOPIC' : 'USER_STATUS' ), m[0][1] ].join ' '    
  end


  def snapshot_info
    @data = post_id.split ' '
    return nil if @data.length < 4

    origin = try_get_snapshot_info
    return origin if origin

    return nil unless update_token

    origin = try_get_snapshot_info
    return origin if origin

    return self.new_record? ? nil : { likes: 0, reposts: 0, voters: [] }
  end

  protected

  def post_exist?
    @data = post_id.split ' '

    @data.size == 4 && try_get_snapshot_info != nil
  end

  def try_get_snapshot_info
    discussion = api_call({
      method: 'discussions.get',
      discussionId: @data[1],
      discussionType: @data[0],
      fields: 'discussion.like_count,discussion.owner_uid'
    })

    return nil unless discussion

    snapshot_info = { state: { likes: discussion['discussion']['like_count'].to_i, reposts: 0 }, voters: [] }

    return snapshot_info if snapshot_info[:state][:likes] == 0

    likes = api_call({
      method: 'discussions.getDiscussionLikes',
      discussionId: @data[1],
      discussionType: @data[0],
      count: 100,
      fields: 'user.uid,user.url_profile,user.pic128x128'
    })

    return snapshot_info unless likes && likes.has_key('users') && likes['users'].length > 0

    users = Hash[ likes['users'].map { |user| [user['uid'], user] } ]

    friends = api_call({
      method: 'friends.areFriends',
      uids1: Array.new( likes['users'].length, discussion['discussion']['owner_uid'] ).join(','),
      uids2: users.keys.join(',')
    })

    return snapshot_info unless friends

    friends.each do |buddy|
      users[ buddy['uid2'] ][:is_friend] = buddy['are_friends']
    end

    users.each do |id, info|
      snapshot_info[:voters].push({
        url: user['url_profile'],
        liked: true,
        reposted: false,
        relationship: info[:is_friend] ? 'friend' : 'guest',
        has_avatar: true,
        too_friendly: false  
      })
    end

    return snapshot_info
  rescue
    return nil
  end

  def api_call( params )
    params[:application_key] = Vote::Application.config.social[:ok][:public]
    params_str = params.sort.collect { |c| "#{c[0]}=#{c[1]}" }.join
    params[:sig] = Digest::MD5.hexdigest( params_str + Digest::MD5.hexdigest( @data[2] + Vote::Application.config.social[:ok][:secret] ) )
    params[:access_token] = @data[2]

    response = RestClient.get 'http://api.odnoklassniki.ru/fb.do', params: params
    !response.nil? && JSON.parse(response.body)
  end

  def update_token
    response = RestClient.post 'http://api.odnoklassniki.ru/oauth/token.do', refresh_token: @data[3], grant_type: 'refresh_token', client_id: Vote::Application.config.social[:ok][:id], client_secret: Vote::Application.config.social[:ok][:secret]
    if !response.nil? && (response = JSON.parse(response.body)) && response.has_key?('access_token')
      @data[2] = response['access_token']
      update_attributes post_id: @data.join(' ')
      return true
    else
      return false
    end
  end

  def add_omniauth_to_post_id
    if omniauth
      self.post_id += ' ' + [ omniauth['token'], omniauth['refresh_token'] ].join(' ')
    else
      self.post_id = nil
    end
  end
end
