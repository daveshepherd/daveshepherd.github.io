source "https://rubygems.org"

gem "jekyll", "~> 4.4"

group :jekyll_plugins do
  gem "jekyll-gist", "~> 1.5"
  gem "jekyll-paginate", "~> 1.1"
end

gem "webrick", "~> 1.9"
# Required by octokit (via jekyll-gist) for Faraday v2 retry middleware; not a Jekyll plugin.
gem "faraday-retry", "~> 2.0"
gem "html-proofer", "~> 5.2", group: :test
