module OurnaropaPlanner
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    
    def get_browser
      # Require the gems
      require 'capybara/poltergeist'

      # reset Capy
      Capybara.reset_sessions!
      
      # Configure Poltergeist to not blow up on websites with js errors aka every website with js
      # See more options at https://github.com/teampoltergeist/poltergeist#customization
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 5.minutes)
      end

      # Configure Capybara to use Poltergeist as the driver
      Capybara.default_driver = :poltergeist
      
      return Capybara.current_session     
    end
  end
end
