require 'factory_girl'

FactoryGirl.define do 
  factory :task_list do 
  end

  factory :task do 
    association :task_list
    sequence(:title) {|n| "My Task #{n}"}
  end
end