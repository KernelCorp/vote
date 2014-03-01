source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2', '0.3.11'
gem 'haml-rails'
gem 'slim-rails'
gem 'activemerchant', :require => 'active_merchant'
gem 'bcrypt-ruby', '~> 3.0.0'

#social nets
gem 'rest-client'
gem 'koala', '~> 1.8.0rc1' #facebook
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-odnoklassniki'
gem 'omniauth-mailru'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
 

# Whenever do the job
gem 'whenever'#, :git => 'https://github.com/javan/whenever', :branch => 'rails3'

# Be freindly
gem 'friendly_id'

# Design your own page
gem 'active_admin_editor'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
  gem 'jquery-ui-sass-rails'
  gem 'blueimp-load-image-rails'
  gem 'font-awesome-sass'
  gem 'remotipart'
end


gem 'jquery-rails', '< 3.0.0'

gem 'cancan'
gem 'devise'
gem 'paperclip', '~> 3.5.0'
gem 'rails-i18n', '~> 3.0.0.pre'
gem 'activeadmin'
gem 'russian'

# Nested forms with dynamic adding and removing
gem 'cocoon'

group :development, :test do
  gem 'selenium-webdriver'
  # Time travel with delorean
  gem 'delorean'
end

# For deploy
group :development do
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'nginx-config'
end

# Use unicorn as the app server
gem 'unicorn', :platforms => :ruby

group :test do
  gem 'capybara'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rack'
  gem 'coveralls', require: false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

local_gemfile = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.exists?(local_gemfile)
  puts "Loading Gemfile.local ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(local_gemfile)
end
