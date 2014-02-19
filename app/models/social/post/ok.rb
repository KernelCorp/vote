=begin
class Social::Post::Ok < Social::Post
  def calculate_signature(params)
    str = params.sort.collect { |c| "#{c[0]}=#{c[1]}" }.join('')
    Digest::MD5.hexdigest str + Digest::MD5.hexdigest( access_token.token + options.client_secret )
  end


  def self.post_id_from_url( url )
    m = url.scan /\/(topic|statuses)\/(\d+)/ 

    return nil if m.empty?

    m[0] = (m[0] == 'topic') ? 'GROUP_TOPIC' : 'USER_STATUS'

    '/fb.do?method=discussions.get&discussionId=388785809016&discussionType=USER_PHOTO&session_key=[Session key]&application_key=[Application Key]&sig=[Signature]'




    message
    like_summary

    if m.include? '/'
      t = m.split('/')[0].upcase
    else
      t = response['type']
    end

    return nil if not [ 'GROUP', 'PROFILE' ].include? t

    m = m[0]

    response = @@API.fql_query "SELECT id FROM profile WHERE username = \"#{m[0]}\" OR id = \"#{m[0]}\""

    return response.empty? ? nil : "#{response[0]["id"]}_#{m[1]}"
  end

  def get_subclass_origin
    response = @@API.fql_query "SELECT message, like_info.like_count, share_info.share_count FROM stream WHERE post_id = \"#{post_id}\""

    if response.empty?
      @origin = nil
    else
      response = response[0]
      @origin = {
        likes:   response['like_info']['like_count'],
        reposts: response['share_info']['share_count'],
        text:    response['message']
      }
    end
  end
end
=end
