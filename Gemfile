source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem "sorcery"
gem "haml-rails"
gem "will_paginate"
gem "will_paginate_mongoid"
gem 'jquery-rails'
gem "mongoid", "~> 3.0.0"
gem 'mongoid_auto_increment'
gem 'bson_ext'
gem 'json'
gem 'wrest'
gem 'nokogiri'
gem "rails_config"
gem "mongoid-paperclip", :require => "mongoid_paperclip"
gem 'aws-sdk', '~> 1.3.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "less-rails" 
  gem 'bootstrap-sass'
  gem 'execjs'
  gem "twitter-bootstrap-rails",:git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end
group :development do
  gem 'thin'
  gem 'capistrano'
  gem 'capistrano-unicorn', :require => false
  gem 'rvm-capistrano'
end
group :production do
  gem 'unicorn'
  gem 'mysql2'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
