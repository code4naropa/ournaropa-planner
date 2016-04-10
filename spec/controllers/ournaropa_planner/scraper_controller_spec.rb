require 'spec_helper'

module OurnaropaPlanner
  
  describe ScraperController, type: :controller do
    
    routes { OurnaropaPlanner::Engine.routes }
      
    describe "GET #scrape" do

      before do
        get :scrape
        @browser = assigns(:browser)
        @fetched_courses = assigns(:courses)
      end  
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "signs in successfully" do        
        username == @browser.find("#userWelcome strong").text
        expect(username).to eq("Finn Janek Woelm")
      end
      
      it "navigates to registration page" do
        current_url =  @browser.current_url
        expect(current_url).to start_with("https://my.naropa.edu/ICS/Student/Registration/Register_for_Classes_and_Academic_Information.jnz")
      end
      
      it "searches Fall 2016 courses" do
        is_fall_2016_selected =  @browser.find("#pg0_V_ddlTerm option", :text => "FA 2016").selected?
        expect(is_fall_2016_selected).to be(true)
      end
      
      it "finds all the courses" do
        num_classes = @browser.all("#pg0_V_dgCourses > tbody > tr:not(.subItem)").count
        expect(num_classes).to eq(427)
      end
      
      xit "gets courses from the Internet" do
        
      end
      
      it "creates classes" do        
        expect(Course.all.count).to eq( @fetched_courses.count)
      end
    end

  end
end
