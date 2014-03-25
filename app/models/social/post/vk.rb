class Social::Post::Vk < Social::Post

  def self.post_id_from_url( url )
    id = url.scan /\=wall(-?\d+_\d+)/

    id.empty? ? nil : id[0][0]
  end

  def snapshot_info
    ids = post_id.split '_'

    data = vk_procedure 'social_snapshot', owner: ids[0], post: ids[1]

    data['users'] = data['users'].to_h

    snapshot_info = { state: { likes: data['likes'].size, reposts: data['reposts'].size }, voters: [] }

    data['likes'].each do |voter|
      relationship = 'guest'

      if data['friends']
        if data['friends'].include? voter
          relationship = 'friend'
        elsif data['followers'].include? voter
          relationship = 'follower'
        end
      end

      snapshot_info[:voters].push({
        url: "http://vk.com/id#{voter}",
        reposted: data['reposts'].include?(voter),
        relationship: relationship,
        avatared: data['users'][voter]['avatar'],
        too_friendly: data['users'][voter]['friends'].to_i > 1000    
      })
    end

    return snapshot_info

  end

  protected

  def vk_procedure( name, args_hash )
    JSON.parse( Net::HTTP.get_response( URI.parse("https://api.vk.com/method/execute.#{name}?#{args_hash.to_query}") ).body )['response']
  end

end
