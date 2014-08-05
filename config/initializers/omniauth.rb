# omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :salesforce, ENV['SALESFORCE_KEY'], ENV['SALESFORCE_SECRET'],
  client_options: {
    ssl: { :ca_file => ENV['CA_FILE'] }
  }
end
