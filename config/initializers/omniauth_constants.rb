require 'rest_client'
require 'koala'

TWITTER_ENCODED = Base64.strict_encode64 "#{Vote::Application.config.social[:tw][:key]}:#{Vote::Application.config.social[:tw][:secret]}".force_encoding('UTF-8')

RestClient::Resource.new("https://api.twitter.com/oauth2/token/").post(
  'grant_type=client_credentials', 
  {
    'Authorization' => "Basic #{TWITTER_ENCODED}",
    'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
  }
) do |response, request, result|
  Vote::Application.config.social[:tw][:token] = JSON.parse(response.body)["access_token"]
end


Koala.config.api_version = "v1.0"

Vote::Application.config.social[:fb][:oauth] = Koala::Facebook::OAuth.new( 
  Vote::Application.config.social[:fb][:id], 
  Vote::Application.config.social[:fb][:secret] 
)
