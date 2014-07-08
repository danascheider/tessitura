require 'factory_girl'

FactoryGirl.define do 
  factory :task do 
    sequence(:title) {|n| "My Task #{n}"}
  end
end