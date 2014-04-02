class Social::Post::Mm < Social::Post
  def self.post_id_from_url( url )
    profile = url.scan /my\.mail\.ru.*\/((?:mail|community)\/[^\/]+)/
    post = url.scan /post_id=(\w+)/

    response = JSON.parse( RestClient::Resource.new("http://appsmail.ru/platform/#{profile[0][0]}").get.body )

    return nil unless response.has_key?('uid')

    "#{response['uid']}/#{post[0][0].downcase}"
  rescue
    nil
  end

  def snapshot_info
    snapshot_info = nil

    id = post_id.split '/'

    likes = 0

    response = JSON.parse( RestClient::Resource.new( api_url( id[0], id[1] ) ).get.body )[0]

    snapshot_info = { state: { likes: response['likes'].size, reposts: 0 }, voters: [] }

    response['likes'].each do |voter|
      begin
        snapshot_info[:voters].push({
          url: voter['link'],
          liked: true,
          reposted: false,
          relationship: '',
          has_avatar: voter['has_pic'],
          too_friendly: voter.has_key?('friends_count') && voter['friends_count'] > 1000
        })
      rescue
        next
      end
    end

    snapshot_info
  rescue
    snapshot_info
  end

  protected

  def post_exist?
    !post_id.blank?
  end

  def api_url( uid, pid )
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

end
