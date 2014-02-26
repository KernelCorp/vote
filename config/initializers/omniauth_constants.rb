require 'rest_client'
require 'koala'



TWITTER_KEY = URI::encode '0OWBo1trD6OIhIWODJG5YQ'
TWITTER_SECRET = URI::encode '9CofnoN9mC13lvCdi0DbNKf8ktvYxMVxoQm8F0FgLUI'
TWITTER_ENCODED = Base64.strict_encode64 "#{TWITTER_KEY}:#{TWITTER_SECRET}".force_encoding('UTF-8')

resource = RestClient::Resource.new("https://api.twitter.com/oauth2/token/")

options = {}
options['Authorization'] = "Basic #{TWITTER_ENCODED}"
options['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'

resource.post('grant_type=client_credentials', options) do |response, request, result|
  TWITTER_TOKEN = JSON.parse(response.body)["access_token"]
end



FACEBOOK_ID = '223856571138985'
FACEBOOK_SECRET = '7f9d9d5ac51a1c25f98acf01a28b96a6'

FACEBOOK_OAUTH = Koala::Facebook::OAuth.new( FACEBOOK_ID, FACEBOOK_SECRET )



#MIR_ID = '717523'
#MIR_PRIVATE = 'a486c5db8249e08e6a422b61d519983c'
#MIR_SECRET = 'cc7ed0f189d1e09e6cccc6616630f5c8'

MIR_ID = '717466'
MIR_PRIVATE = '53032931be1f398a278920508001d2c1'
MIR_SECRET = '065711e9d4eb2961868d0c2dac132bf7'



OK_ID = '223956224'
OK_PUBLIC = 'CBAOEKFOABABABABA'
OK_SECRET = 'EA5E278826141A8021237C6F'
