Rails.application.routes.draw do

  mount OurnaropaPlanner::Engine => "/ournaropa_planner", as: :planner
end
