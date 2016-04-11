OurnaropaPlanner::Engine.routes.draw do
  
  get 'scraper/scrape', as: :scrape

  get 'courses', to: 'courses#index'
  
  get 'search', to: 'courses#search', as: :search
  
  root 'courses#index'
  
end
