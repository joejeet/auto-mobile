source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'rake' , '>= 0.9.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jruby-openssl'
  gem 'torquebox', '2.1.1'
  # the javascript engine for execjs gem

  group :assets do
    gem 'therubyrhino'
  end
end

platforms :ruby, :mswin, :mingw do
  gem 'pg'
end

# To create User Authentication & Authorization
gem 'devise'
gem 'cancan'
gem 'gon'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino'

  # CSS and JavaScript library for Styling and User Interface
  gem 'anjlab-bootstrap-rails', '2.1.1.1', :require => 'bootstrap-rails'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'foreigner'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'gon'
gem 'deep_cloneable', '~> 1.4.0'
gem 'ancestry'