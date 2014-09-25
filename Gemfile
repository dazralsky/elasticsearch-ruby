source 'https://rubygems.org'

gem "bundler", "> 1"
gem "rake"

gem 'elasticsearch', :path => File.expand_path("../elasticsearch", __FILE__), :require => false

gem "pry"
gem "ansi"
gem "shoulda-context"
gem "mocha"
gem "yard"

platforms :ruby_19, :ruby_20, :ruby_21 do
  gem "ruby-prof"
  gem "simplecov"
  gem "cane"
  gem "require-prof"
  gem "coveralls"
end
