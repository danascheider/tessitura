require 'factory_girl'

FactoryGirl.define do 
  to_create {|i| i.save }
  
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

    factory :task_list_with_complete_and_incomplete_tasks do 
      ignore do 
        complete_tasks_count 2
        incomplete_tasks_count 3
      end

      after(:create) do |list, evaluator|
        create_list(:task, evaluator.incomplete_tasks_count, task_list: list)
        create_list(:complete_task, evaluator.complete_tasks_count, task_list: list)
      end
    end
  end

  factory :task do 
    association :task_list
    sequence(:title) {|n| "My Task #{n}"}
    status 'New'
    priority 'Normal'

    factory :task_with_deadline do 
      sequence(:deadline) { Time.now }
    end

    factory :complete_task do 
      status 'Complete'
    end
  end

  factory :user do 
    sequence(:email) {|n| "user#{n}@example.com"}
    sequence(:username) {|n| "user-25#{n}"}
    sequence(:password) {|n| "p4ssw0rd#{n}"}
    country 'USA'

    factory :admin do 
      admin true
    end

    factory :user_with_task_lists do 
      ignore do 
        lists_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:task_list_with_tasks, evaluator.lists_count, user: user)
      end
    end
  end
end