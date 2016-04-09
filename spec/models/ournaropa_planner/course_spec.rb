require 'spec_helper'

module OurnaropaPlanner
  describe Course, type: :model do
    
    before(:each) do
      @course = FactoryGirl.build(:ournaropa_planner_course)
    end
    
    it "has a valid factory" do
      expect(@course).to be_valid
    end
    
    it "validates all fields" do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:code)
    end
  end
end
