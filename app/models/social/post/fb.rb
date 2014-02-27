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
    m = url.scan /([^\/]+)\/posts\/(\d+)/ 

    return nil if m.empty?

    m = m[0]

    response = @@FB[:api].fql_query "SELECT id FROM profile WHERE username = \"#{m[0]}\" OR id = \"#{m[0]}\""

    response.empty? ? nil : "#{response[0]["id"]}_#{m[1]}"
  end

  def get_subclass_origin
    response = @@FB[:api].fql_query "SELECT message, like_info.like_count, share_info.share_count FROM stream WHERE post_id = \"#{post_id}\""

    return nil if response.empty?

    response = response[0]

    return nil unless response.has_key?('message')

    origin = {
      likes:   response['like_info']['like_count'],
      reposts: response['share_info']['share_count'],
      text:    response['message']
    }

    origin
  end
end
