class Social::Post::Vk < Social::Post

  def self.post_id_from_url( url )
    id = url.scan /\=wall(-?\d+_\d+)/

    id.empty? ? nil : id[0][0]
  end

  def get_subclass_origin
    response = Net::HTTP.get_response URI.parse "http://api.vk.com/method/wall.getById?posts=#{post_id}"
    response = JSON.parse(response.body)['response']

    return nil if response.nil?

    response = response.first

    return nil if not response.class == Hash && response.has_key?('text')

    origin = {
      likes:   response['likes']['count'],
      reposts: response['reposts']['count'],
      text:    response['text']
    }

    origin
  end
end
