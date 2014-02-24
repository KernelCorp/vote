Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  #provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET']
  
  provider :twitter, TWITTER_KEY, TWITTER_SECRET

  provider :facebook, FACEBOOK_ID, FACEBOOK_SECRET, scope: 'read_stream'

  provider :mailru, MIR_ID, MIR_PRIVATE

  provider :odnoklassniki, OK_ID, OK_SECRET, public_key: OK_PUBLIC, scope: 'VALUABLE_ACCESS'
end
