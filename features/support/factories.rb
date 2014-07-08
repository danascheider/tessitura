require 'factory_girl'

FactoryGirl.define do 
  factory :task do 
    sequence(:title) {|n| "My Task #{n}"}
    sequence(:index) {|n| n }
  end
end