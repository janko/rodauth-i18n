source "https://rubygems.org"

gemspec

gem "rake", "~> 13.0"
gem "rodauth", ">= 2.16"

if RUBY_ENGINE == "jruby"
  gem "jdbc-sqlite3"
else
  gem "sqlite3"
end
