class Social::Post::Tw < Social::Post

  def self.capture_post_id( url )
    url.gsub /.*status\/(\d+).*/, "\\1"
  end

  def get_subclass_origin
    response = Net::HTTP.get_response URI.parse "https://api.twitter.com/1.1/statuses/show.json?id=#{post_id}"
    response = JSON.parse(response.body)

    if response.nil?
      @origin = nil
    else
      @origin = {
        likes:   response['favourites_count'],
        reposts: response['retweet_count'],
        text:    response['text']
      }
    end
  end
end
