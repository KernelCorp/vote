class Social::Post::Ok < Social::Post::Base
  before_validation :add_omniauth_to_post_id, on: :create

  
  def self.post_id_from_url( url )
    m = url.scan /\/(topic|statuses)\/(\d+)/ 

    return nil if m.empty?

    [ ( (m[0][0] == 'topic') ? 'GROUP_TOPIC' : 'USER_STATUS' ), m[0][1] ].join ' '
  end


  def snapshot_info
    @data = post_id.split ' '

    return nil if @data.length != 4

    try_get_snapshot_info || ( update_token && try_get_snapshot_info )
  end

  protected

  def post_exist?
    post_id && ( @data = post_id.split(' ') ).size == 4 && try_get_snapshot_info
  end

  def try_get_snapshot_info
    snapshot_info = nil

    discussion = api_call({
      method: 'discussions.get',
      discussionId: @data[1],
      discussionType: @data[0],
      fields: 'discussion.like_count,discussion.owner_uid'
    })

    snapshot_info = { state: { likes: discussion['discussion']['like_count'].to_i, reposts: 0 }, voters: [] }

    return snapshot_info if snapshot_info[:state][:likes] == 0

    likes = api_call({
      method: 'discussions.getDiscussionLikes',
      discussionId: @data[1],
      discussionType: @data[0],
      count: 100,
      fields: 'user.uid,user.url_profile,user.pic128x128'
    })

    users = Hash[ likes['users'].map { |user| [user['uid'], user] } ]

    friends = api_call({
      method: 'friends.areFriends',
      uids1: Array.new( users.keys.length, discussion['discussion']['owner_uid'] ).join(','),
      uids2: users.keys.join(',')
    })

    friends.each do |buddy|
      users[ buddy['uid2'] ][:is_friend] = buddy['are_friends']
    end

    users.each do |id, info|
      snapshot_info[:voters].push({
        url: info['url_profile'],
        liked: true,
        reposted: false,
        relationship: info[:is_friend] ? 'friend' : 'guest',
        has_avatar: true,
        too_friendly: false  
      })
    end

    snapshot_info
  #rescue => e
  #  logger.error e.message
  #  snapshot_info
  end

  def api_call( params )
    params[:application_key] = Vote::Application.config.social[:ok][:public]
    params_str = params.sort.collect { |c| "#{c[0]}=#{c[1]}" }.join
    params[:sig] = Digest::MD5.hexdigest( params_str + Digest::MD5.hexdigest( @data[2] + Vote::Application.config.social[:ok][:secret] ) )
    params[:access_token] = @data[2]

    JSON.parse( RestClient.get( 'http://api.odnoklassniki.ru/fb.do', params ).body )
  end

  def update_token
    response = RestClient.post 'http://api.odnoklassniki.ru/oauth/token.do', refresh_token: @data[3], grant_type: 'refresh_token', client_id: Vote::Application.config.social[:ok][:id], client_secret: Vote::Application.config.social[:ok][:secret]
    @data[2] = JSON.parse(response.body)['access_token']
    update_attributes post_id: @data.join(' ')
    true
  rescue
    false
  end

  def add_omniauth_to_post_id
    self.post_id = omniauth && [ post_id, omniauth['token'], omniauth['refresh_token'] ].join(' ')
  end
end
