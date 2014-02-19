require 'rest_client'
require 'koala'



TWITTER_KEY = URI::encode 'R7ZeIed6BAe8u3svowVmg'
TWITTER_SECRET = URI::encode 'xM70Sj4sxLT41i7EY5L2xKkiz5nbZEPGJWw7bFWFa2U'
TWITTER_ENCODED = Base64.strict_encode64 "#{TWITTER_KEY}:#{TWITTER_SECRET}".force_encoding('UTF-8')

resource = RestClient::Resource.new("https://api.twitter.com/oauth2/token/")

options = {}
options['Authorization'] = "Basic #{TWITTER_ENCODED}"
options['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'

resource.post('grant_type=client_credentials', options) do |response, request, result|
  TWITTER_TOKEN = JSON.parse(response.body)["access_token"]
end



FACEBOOK_ID = '1393731780890981'
FACEBOOK_SECRET = '7d8bcdf8d21bfe1292c82705e966a6d0'
FACEBOOK_OAUTH = Koala::Facebook::OAuth.new( FACEBOOK_ID, FACEBOOK_SECRET )
