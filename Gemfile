source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'haml-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

end

gem 'jquery-rails'

gem 'cancan'
gem 'devise'
gem 'paperclip'

group :development, :test do
  gem 'cucumber-rails', require: false
  gem 'selenium-webdriver'
end

#for deploy
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

# To use debugger
#gem 'debugger'
