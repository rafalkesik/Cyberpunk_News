source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~>3.1.2'

gem 'bcrypt',                  '3.1.18'
gem 'bootsnap',                '1.12.0', require: false
gem 'bootstrap-will_paginate', '1.0.0'
gem 'faker',                   '2.21.0'
gem 'importmap-rails',         '1.1.0'
gem 'jbuilder',                '2.11.5'
gem 'polish',                  '~> 0.1.0'
gem 'puma',                    '5.6.4'
gem 'rails',                   '~> 7.1.0'
gem 'rubocop',                 '~> 1.71'
gem 'rubocop-erb',             '~> 0.3.0'
gem 'sassc-rails',             '2.1.2'
gem 'sprockets-rails',         '3.4.2'
gem 'stimulus-rails',          '1.0.4'
gem 'turbo-rails',             '1.1.1'
gem 'will_paginate',           '3.3.1'

group :development, :test do
  gem 'debug',       '1.9.2', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 7.0.0'
  gem 'sqlite3',     '~> 1.5'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'web-console', '4.2.0'
end

group :test do
  gem 'capybara',                 '3.37.1'
  gem 'guard',                    '2.18.0'
  gem 'listen',                   '~> 3.7'
  gem 'minitest',                 '5.15.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'selenium-webdriver',       '4.2.0'
  gem 'webdrivers',               '5.0.0'
end

group :production do
  gem 'pg', '1.3.5'
end
