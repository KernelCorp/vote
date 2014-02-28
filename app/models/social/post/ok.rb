class Social::Post::Ok < Social::Post
  before_validation :add_omniauth_to_post_id, on: :create

  
  def self.post_id_from_url( url )
    m = url.scan /\/(topic|statuses)\/(\d+)/ 

    return nil if m.empty?

    [ ( (m[0][0] == 'topic') ? 'GROUP_TOPIC' : 'USER_STATUS' ), m[0][1] ].join ' '    
  end


  def get_subclass_origin
    data = post_id.split ' '

    origin = get_subclass_origin_from_data( data )
    return origin if not origin.nil?

    response = RestClient.post 'http://api.odnoklassniki.ru/oauth/token.do', refresh_token: data[3], grant_type: 'refresh_token', client_id: Vote::Application.config.social[:ok][:id], client_secret: Vote::Application.config.social[:ok][:secret]
    if !response.nil? && (response = JSON.parse(response.body)) && response.has_key?('access_token')
      data[2] = response['access_token']
      update_attributes post_id: data.join(' ')
    else
      return nil
    end

    origin = get_subclass_origin_from_data( data )
    return origin if not origin.nil?

    return self.new_record? ? nil : { likes: 0, reposts: 0, text: '' }
  end


  def self.params_from_data( data )
    params = 
    {
      method: 'discussions.get',
      discussionId: data[1],
      discussionType: data[0],
      application_key: Vote::Application.config.social[:ok][:public],
      fields: 'discussion.like_count,discussion.title,discussion.message'
    }

    params_str = params.sort.collect { |c| "#{c[0]}=#{c[1]}" }.join
    params[:sig] = Digest::MD5.hexdigest( params_str + Digest::MD5.hexdigest( data[2] + Vote::Application.config.social[:ok][:secret] ) )
    params[:access_token] = data[2]

    return params
  end

  
  protected


  def get_subclass_origin_from_data( data )
    response = RestClient.get 'http://api.odnoklassniki.ru/fb.do', params: self.class.params_from_data(data)

    if !response.nil? && (response = JSON.parse(response.body)) && response.has_key?('discussion')
      response = response['discussion']
      origin = {
        likes:   response['like_count'],
        reposts: 0,
        text:    response['title'] + ' ' + response['message']
      }
      return origin
    else
      return nil
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
