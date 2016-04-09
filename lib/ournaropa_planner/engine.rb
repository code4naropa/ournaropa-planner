module OurnaropaPlanner
  class Engine < ::Rails::Engine
    isolate_namespace OurnaropaPlanner
    
    
    # Here, we're telling Rails when generating models, controllers, etc. for your engine to use RSpec and FactoryGirl, instead of the default of Test::Unit and fixtures
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end  
    
  end
end
