class Social::Post::Vk < Social::Post

  def self.capture_post_id( url )
    url.gsub /.*wall((-?\d+_?\d*)?).*/, "\\1"
  end

  def get_subclass_origin
    response = Net::HTTP.get_response URI.parse "http://api.vk.com/method/wall.getById?posts=#{post_id}"
    response = JSON.parse(response.body)['response']

    if response.nil?
      @origin = nil
    else
      response = response.first
      @origin = {
        likes:   response['likes']['count'],
        reposts: response['reposts']['count'],
        text:    response['text']
      }
    end
  end
end
