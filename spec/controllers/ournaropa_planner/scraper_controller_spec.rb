require 'spec_helper'

module OurnaropaPlanner
  describe ScraperController, type: :controller do

    routes { OurnaropaPlanner::Engine.routes }
    
    describe "GET #scrape" do
      before do
        get :scrape
        @fetched_courses = assigns(:courses)
      end      
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      xit "gets courses from the Internet" do
        
      end
      
      it "creates classes" do        
        expect(Course.all.count).to eq(@fetched_courses.count)
      end
    end

  end
end
