source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

# Activerecord and database gems
group :db do
  # Use postgresql as the database for Active Record
  gem 'pg'
end

# Authentication and authorization
group :auth do
end

group :assets do
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 2.7.0'
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use Bootstrap 3 with Rails 4
gem 'bootstrap-sass', '~> 3.3.5'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Need imagemagick! `sudo apt-get install imagemagick`
gem 'paperclip', '~> 4.3'

group :development do
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'web-console', '~> 2.0'
end

group :development, :test do
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 5.0.3'
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'
  # Use RSpec for tests
  gem 'rspec-rails', '~> 3.0.0'
  # And Factory Girls instead default fixtures
  gem 'factory_girl_rails', '>= 4.4.1'
  # gem 'faker'
end

group :test do
  gem 'capybara', '>= 2.4.1'
  gem 'database_cleaner', '>= 1.3.0'
  # gem 'email_spec'
  # gem 'timecop'
  gem 'launchy', '>= 2.4.2'
  gem 'cucumber-rails', '>= 1.4.1', require: false
end

# Use HAML for views
gem 'haml'
gem 'haml-rails', '>= 0.5.3', group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
