$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ournaropa_planner/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ournaropa_planner"
  s.version     = OurnaropaPlanner::VERSION
  s.authors     = ["Finn Woelm"]
  s.email       = ["finn.woelm@gmail.com"]
  s.homepage    = "http://www.ournaropa.org/"
  s.summary     = "To be added."
  s.description = "To be added."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
  
  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "pg"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'faker'
  
  s.add_development_dependency 'figaro'
end
