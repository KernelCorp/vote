class Social::Post::Vk < Social::Post::Base
  def self.post_id_from_url( url )
    id = url.scan /wall(-?\d+_\d+)/

    id.empty? ? nil : id[0][0]
  end

  def snapshot_info
    snapshot_info = nil

    ids = post_id.split '_'
    owner_is_user = /^[^\-]/.match( ids[0] ) != nil

    likes   = items_api_call 'likes.getList', type: 'post', owner_id: ids[0], item_id: ids[1], count: 1000, post: true
    reposts = items_api_call 'likes.getList', type: 'post', owner_id: ids[0], item_id: ids[1], count: 1000, filter: 'copies'

    snapshot_info = { state: { likes: likes.size, reposts: reposts.size }, voters: [] }

    return snapshot_info if snapshot_info[:state][:likes] == 0

    if owner_is_user
      friends   = items_api_call 'friends.get', user_id: ids[0]
      followers = items_api_call 'users.getFollowers', user_id: ids[0], count: 1000
    end

    user_info = {}
    api_call( 'users.get', fields: 'sex,bdate,city,photo_max', user_ids: likes.join(','), post: true ).each do |user|
      data = {}
      data[:gender] = user['sex']   && user['sex'].to_i - 1 
      data[:bdate]  = user['bdate'] && user['bdate'] =~ /^\d+\D\d+\D\d{4}$/ && Date.parse( user['bdate'] ) 
      data[:city]   = user['city']  && user['city']['title'] 
      data[:has_avatar] = user['photo_max'] != 'http://vk.com/images/camera_b.gif'
      user_info[ user['id'] ] = data
    end

    likes.each do |voter|
      relationship = if owner_is_user
        if friends.include? voter
          'friend'
        elsif followers.include? voter
          'follower'
        else
          'guest'
        end
      else  
        'guest'
      end

      url = "http://vk.com/id#{voter}"

      registed_at =
      if voters.where( url: url ).count == 0
        request_registed_at voter
      end

      #too_friendly = items_api_call( 'friends.get', user_id: voter ).size > 1000

      snapshot_info[:voters].push(
        {
          social_id: voter,
          url: url,
          liked: true,
          reposted: reposts.include?(voter),
          relationship: relationship,
          too_friendly: false,
          registed_at: registed_at
        }
        .merge! user_info[ voter ].to_h
      )
    end

    snapshot_info
  rescue => e
    logger.error e.message
    snapshot_info
  end

  def request_registed_at( voter )
    @sid = request_registed_at_sid if @sid.nil?

    retried = false
    begin
      return if @sid.nil?
      result = RestClient.post 'http://api.smsanon.ru/vk.com', { paramId: voter }, cookies: { sid: @sid }
    rescue
      return if retried
      retried = true
      
      @sid = request_registed_at_sid
    end

    if result =~ /Дата:(.+)\sGMT/
      $1.gsub(/<[^>]*>/, '').gsub!('&nbsp;', ' ')
    end
  end

  def self.get_group_members( group_id )
    result = []
    offset = 0
    while true
      members = items_api_call 'groups.getMembers', group_id: group_id, offset: offset, count: 1000
      break if members.blank?
      result.push *members
      offset += 1000
    end
    result
  end

  protected

  def request_registed_at_sid
    RestClient.get('http://api.smsanon.ru/').cookies['sid']
  rescue
    nil
  end 

  def post_exist?
    ! api_call( 'wall.getById', posts: post_id, copy_history_depth: 0 ).empty?
  end

  def self.api_call( method, args_hash )
    args_hash[:v] = 5.16

    if args_hash.delete :post
      req = Net::HTTP.post_form URI.parse("http://api.vk.com/method/#{method}"), args_hash
    else
      req = Net::HTTP.get_response URI.parse "http://api.vk.com/method/#{method}?#{args_hash.to_query}"
    end

    JSON.parse( req.body )['response']
  end
  def api_call( *args )
    self.class.api_call *args
  end

  def self.items_api_call( method, args_hash )
    result = api_call method, args_hash
    !result.nil? && result.has_key?('items') ? result['items'] : []
  end
  def items_api_call( *args )
    self.class.items_api_call *args
  end

end
