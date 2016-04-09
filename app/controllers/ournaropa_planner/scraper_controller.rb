require_dependency "ournaropa_planner/application_controller"

module OurnaropaPlanner
  class ScraperController < ApplicationController
    def scrape
      
      @courses = [
        {name: "abc",
          code: "COR 215"}
        ]
      
      # create courses
      @courses.each do |course|
        Course.create(:name => course[:name], :code => course[:code])
      end
      
    end
  end
end
