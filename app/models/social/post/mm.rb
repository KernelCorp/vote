class Social::Post::Mm < Social::Post
  def self.post_id_from_url( url )
    profile = url.scan /my\.mail\.ru.*\/((?:mail|community)\/[^\/]+)/
    post = url.scan /post_id=(\w+)/

    return nil if profile.empty? || post.empty?

    RestClient::Resource.new("http://appsmail.ru/platform/#{profile[0][0]}").get do |response|
      return nil if response.nil?
      response = JSON.parse(response.body)
      return nil if not response.has_key?('uid')

      return "#{response['uid']}/#{post[0][0].downcase}"
    end
  end

  def self.post_info_query( uid, pid )
    params = {
      method: 'stream.getByAuthor',
      uid: uid,
      skip: pid,
      limit: 1,
      app_id: Vote::Application.config.social[:mm][:id],
      secure: 1
    }

    params[:sig] = Digest::MD5.hexdigest( params.sort.collect { |c| "#{c[0]}=#{c[1]}" }.join('') + Vote::Application.config.social[:mm][:secret] )

    'http://www.appsmail.ru/platform/api?' + params.collect { |c| "#{c[0]}=#{c[1]}" }.join('&')
  end

  def get_subclass_origin
    id = post_id.split '/'

    RestClient::Resource.new( self.class.post_info_query( id[0], id[1] ) ).get do |response|
      puts response

      return nil if response.nil?
      response = JSON.parse(response.body)
      return nil if not response.class == Array and response.length == 1 
      response = response[0]
      return nul if not response.has_key?('likes')
      origin = {
        likes:   response['likes'].size,
        reposts: 0,
        text:    ''
      }
    end

    origin
  end
end
