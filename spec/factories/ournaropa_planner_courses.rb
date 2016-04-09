FactoryGirl.define do
  factory :ournaropa_planner_course, class: 'OurnaropaPlanner::Course' do
    name          { Faker::Name.name }
    code          { Faker::Lorem.characters(3).upcase + " " + Faker::Lorem.characters(3).upcase }
    requirements  { Faker::Lorem.words(10) }
    books         { Faker::Lorem.words(10) }
  end
end
