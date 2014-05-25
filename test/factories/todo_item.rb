FactoryGirl.define do 
  factory :todo_item do 
    association :user
    sequence(:title) {|i| "To-do Item #{i}"}
    status 'Blocking'
  end
end