OurnaropaPlanner::Engine.routes.draw do
  
  get 'scraper/scrape', as: :scrape

  get 'courses', to: 'courses#index'
  
end
