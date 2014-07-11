require 'factory_girl'

FactoryGirl.define do 
  factory :task_list do 
  end

  factory :task do 
    association :task_list
    sequence(:title) {|n| "My Task #{n}"}

    factory :task_with_deadline do 
      sequence(:deadline) { Time.now }
    end
  end
end