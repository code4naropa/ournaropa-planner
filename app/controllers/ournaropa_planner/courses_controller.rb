require_dependency "ournaropa_planner/application_controller"

module OurnaropaPlanner
  class CoursesController < ApplicationController
    
    def index
      @courses = Course.all
    end
    
  end
end
