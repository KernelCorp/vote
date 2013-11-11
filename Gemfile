source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2'
gem 'haml-rails'
gem 'activemerchant', :require => 'active_merchant'

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
gem 'paperclip'
gem 'rails-i18n', '~> 3.0.0.pre'
gem 'activeadmin'
gem 'russian'

# Nested forms with dynamic adding and removing
gem 'cocoon'

group :development, :test do
  gem 'cucumber-rails', require: false
  gem 'selenium-webdriver'
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
