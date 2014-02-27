class Social::Post::Tw < Social::Post

  def self.post_id_from_url( url )
    id = url.scan /status\/(\d+)/

    id.empty? ? nil : id[0][0]
  end

  def get_subclass_origin
    resource = RestClient::Resource.new("https://api.twitter.com/1.1/statuses/show.json?trim_user=true&include_entities=false&id=#{post_id}")
    resource.get( { 'Authorization' => "Bearer #{Vote::Application.config.social[:tw][:token]}" } ) do |response|
      return nil if response.nil?

      response = JSON.parse(response.body)

      return nil unless response.has_key?('text')

      origin = {
        likes:   response['favorite_count'],
        reposts: response['retweet_count'],
        text:    response['text']
      }

      return origin
    end
  end
end
