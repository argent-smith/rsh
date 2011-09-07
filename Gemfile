source "http://rubygems.org"

group :test do
  gem "rspec"

  # Travis CI ZenTest bug workaround
  unless ENV['TRAVIS']
    gem "ZenTest"
    gem "test-unit"
    gem "redgreen"
  end
end

group :development do
  gem "jeweler"
  gem "rdoc"
end
