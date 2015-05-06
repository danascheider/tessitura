require 'factory_girl'

FactoryGirl.define do 
  to_create {|i| i.save }

  factory :organization do 
    sequence(:name) {|n| "Organization #{n}" }
    sequence(:website) {|n| "http://www.organization#{n}.org" }

    factory :organization_with_programs do 
      transient do 
        program_count 2
      end

      after(:create) do |org, evaluator|
        create_list(:program, evaluator.program_count, organization: org)
      end
    end

    factory :organization_with_everything do 
      transient do 
        program_count 2
      end

      after(:create) do |org, evaluator|
        create_list(:program_with_everything, evaluator.program_count, organization: org)
      end
    end
  end

  factory :program do 
    organization
    sequence(:name) {|n| "Program #{n}" }
    type 'Competition'
    country 'USA'
    region 'New York'
    city 'New York City'

    factory :program_with_season do 
      after(:create) do |program, evaluator|
        create(:season, program: program)
      end
    end

    factory :program_with_everything do 
      transient do 
        fresh_count 1
        stale_count 2
      end

      after(:create) do |program, evaluator|
        create_list(:season_with_everything, evaluator.fresh_count, program: program)
        create_list(:stale_season, evaluator.stale_count, program: program)
      end
    end
  end

  factory :season do 
    program
    final_deadline Date.new(2015,8,1)
    start_date Date.new(2015,8,22)

    factory :stale_season do 
      stale true
    end

    factory :season_with_listing do 
      after(:create) do |season, evaluator|
        create(:listing, season: season)
      end
    end

    factory :season_with_auditions do 
      transient do 
        audition_count 4
      end

      after(:create) do |season, evaluator|
        create_list(:audition, evaluator.audition_count, season: season)
      end
    end

    factory :season_with_everything do 
      transient do 
        audition_count 4
      end

      after(:create) do |season, evaluator|
        create_list(:audition, evaluator.audition_count, season: season)
        create(:listing, season: season)
      end
    end
  end

  factory :listing do 
    association :season
    sequence(:title) {|n| "Program #{n}" }
  end

  factory :audition do 
    season
    country 'USA'
    region 'New York'
    city 'New York City'
    sequence(:date) {|n| Date.today + n }
    deadline Date.new(2015,2,15)
  end
  
  factory :task_list do 
    association :user
    sequence(:title) {|n| "Task List #{n}"}

    factory :task_list_with_tasks do 
      transient do 
        tasks_count 3
      end

      after(:create) do |list, evaluator|
        create_list(:task, evaluator.tasks_count, task_list: list)
      end
    end

    factory :task_list_with_complete_and_incomplete_tasks do 
      transient do 
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

    first_name 'Test'
    last_name 'User'
    country 'USA'

    factory :admin do 
      admin true
    end

    factory :user_with_task_lists do 
      transient do 
        lists_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:task_list_with_complete_and_incomplete_tasks, evaluator.lists_count, user: user)
      end
    end
  end
end