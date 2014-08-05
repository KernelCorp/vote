data = Vote::Application.config.social

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :vkontakte, data[:vk][:key], data[:vk][:secret]
  
  provider :twitter, data[:tw][:key], data[:tw][:secret]

  provider :facebook, data[:fb][:id], data[:fb][:secret], scope: 'read_stream', secure_image_url: true, :client_options => {:ssl => {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}

  provider :mailru, data[:mm][:id], data[:mm][:private]

  provider :odnoklassniki, data[:ok][:id], data[:ok][:secret], public_key: data[:ok][:public], scope: 'VALUABLE_ACCESS'
end
