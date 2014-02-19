class Social::Post::Tw < Social::Post

  def self.post_id_from_url( url )
    url.gsub /.*status\/(\d+).*/, "\\1"
  end

  def get_subclass_origin
    resource = RestClient::Resource.new("https://api.twitter.com/1.1/statuses/show.json?trim_user=true&include_entities=false&id=#{post_id}")
    options = { 'Authorization' => "Bearer #{TWITTER_TOKEN}" }
    resource.get( options ) do |response|
      if response.nil?
        @origin = nil
      else
        puts response
        response = JSON.parse(response.body)
        @origin = {
          likes:   response['favorite_count'],
          reposts: response['retweet_count'],
          text:    response['text']
        }
      end
    end
  end
end
