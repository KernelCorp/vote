class Social::Post::Fb < Social::Post
  cattr_accessor :API, instance_accessor: false do '' end

  def self.url_for_oauth( callback )
    FACEBOOK_OAUTH.url_for_oauth_code permissions: 'read_stream', callback: callback
  end
  def self.update_api_token( code )
    token = FACEBOOK_OAUTH.get_access_token code
    token = FACEBOOK_OAUTH.exchange_access_token token
    @@API = Koala::Facebook::API.new token
  end


  def self.post_id_from_url( url )
    m = url.scan /([^\/]+)\/posts\/(\d+)/ 

    return nil if m.empty?

    m = m[0]

    response = @@API.fql_query "SELECT id FROM profile WHERE username = \"#{m[0]}\" OR id = \"#{m[0]}\""

    response.empty? ? nil : "#{response[0]["id"]}_#{m[1]}"
  end

  def get_subclass_origin
    response = @@API.fql_query "SELECT message, like_info.like_count, share_info.share_count FROM stream WHERE post_id = \"#{post_id}\""

    return nil if response.empty?

    response = response[0]

    return nil if not response.has_key?('message')

    origin = {
      likes:   response['like_info']['like_count'],
      reposts: response['share_info']['share_count'],
      text:    response['message']
    }

    origin
  end
end
