class Social::Post::Mm < Social::Post::Base
  def self.post_id_from_url( url )
    profile = url.scan /my\.mail\.ru.*\/((?:mail|community)\/[^\/]+)/
    post = url.scan /post_id=(\w+)/

    response = JSON.parse( RestClient.get("http://appsmail.ru/platform/#{profile[0][0]}").body )

    return nil unless response.has_key?('uid')

    "#{response['uid']}/#{post[0][0].downcase}"
  rescue
    nil
  end

  def snapshot_info

    snapshot_info = nil

    id = post_id.split '/'

    friends = api_call({
      method: 'friends.get',
      ext: 0
    })

    post = api_call({
      method: 'stream.getByAuthor',
      uid: id[0],
      skip: id[1],
      limit: 1
    }).first

    snapshot_info = { state: { likes: post['likes'].size, reposts: 0 }, voters: [] }

    post['likes'].each do |voter|
      begin
        snapshot_info[:voters].push({
          url: voter['link'],
          liked: true,
          reposted: false,
          relationship: ( friends.include?(voter['uid']) ? 'friend' : 'guest' ),
          has_avatar: voter['has_pic'],
          too_friendly: voter.has_key?('friends_count') && voter['friends_count'] > 1000
        })
      rescue
        next
      end
    end

    snapshot_info
   rescue => e
    logger.error e.message
    snapshot_info
  end

  protected

  def post_exist?
    snapshot_info
  end

  def api_call( params )
    params[:app_id] = Vote::Application.config.social[:mm][:id]
    params[:secure] = 1
    params[:sig] = Digest::MD5.hexdigest( params.sort.collect { |c| "#{c[0]}=#{c[1]}" }.join('') + Vote::Application.config.social[:mm][:secret] )

    JSON.parse( RestClient.get( 'http://www.appsmail.ru/platform/api?' + params.to_query ).body )
  end

end
