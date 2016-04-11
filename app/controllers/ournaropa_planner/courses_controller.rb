require_dependency "ournaropa_planner/application_controller"

module OurnaropaPlanner
  class CoursesController < ApplicationController
    
    # inherit the layout from the main application
    layout 'application'    
    
    def index
      @courses = Course.all.order(code: :asc)
    end
    
    def search

      @query = params[:query].present? ? params[:query] : "*"
      
      @filter = params[:filter].present? ? params[:filter] : "Everything"
      
      search_fields = []
      
      case @filter.downcase
      when "Title".downcase
        search_fields.push(:name)
      when "Instructor".downcase
        search_fields.push(:instructor)
      when "Description".downcase
        search_fields.push(:description)
      when "Code".downcase
        search_fields.push(:code)
      else
        search_fields.push(:name)
        search_fields.push(:instructor)
        search_fields.push(:description)
        search_fields.push(:code)
      end
      
      
      @courses = Course.search @query, order: {_score: :desc, code: :asc}, fields: search_fields, match: :word_middle, highlight: {tag: "<highlight>", fragment_size: 10000}, misspellings: false
      
    end
    
  end
end
