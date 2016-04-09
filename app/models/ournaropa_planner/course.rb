module OurnaropaPlanner
  class Course < ActiveRecord::Base
    
    validates_presence_of :name, :code
  end
end
