require 'factory_girl'

FactoryGirl.define do 
  factory :task_list do 
    association :user
    sequence(:title) {|n| "Task List #{n}"}

    factory :task_list_with_tasks do 
      ignore do 
        tasks_count 3
      end

      after(:create) do |list, evaluator|
        create_list(:task, evaluator.tasks_count, task_list: list)
      end
    end
  end

  factory :task do 
    association :task_list
    sequence(:title) {|n| "My Task #{n}"}

    factory :task_with_deadline do 
      sequence(:deadline) { Time.now }
    end

    factory :complete_task do 
      status 'complete'
    end
  end

  factory :user do 
    sequence(:email) {|n| "user#{n}@example.com"}
    sequence(:secret_key) {|n| "12345abcde#{n}"}
    country 'USA'

    factory :admin do 
      admin true
    end
  end
end