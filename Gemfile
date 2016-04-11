source 'https://rubygems.org'

# Declare your gem's dependencies in ournaropa_planner.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

gem 'jquery'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Fix turbolinks issues
gem 'jquery-turbolinks'

gem 'sass-rails'

gem 'material_icons'

# Materialize
gem 'materialize-sass'


gem 'pry-rails', group: [:development, :test]

group :development do
  gem 'launchy' # allows us to open websites locally
  gem 'puma'
end


group :test do
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'database_cleaner', '~> 1.5'
end