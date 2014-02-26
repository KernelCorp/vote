data = Vote::Application.config.social

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  #provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET']
  
  provider :twitter, data[:tw][:key], data[:tw][:secret]

  provider :facebook, data[:fb][:id], data[:fb][:secret], scope: 'read_stream'

  provider :mailru, data[:mm][:id], data[:mm][:private]

  provider :odnoklassniki, data[:ok][:id], data[:ok][:secret], public_key: data[:ok][:public], scope: 'VALUABLE_ACCESS'
end
