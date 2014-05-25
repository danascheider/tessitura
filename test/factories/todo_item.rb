FactoryGirl.define do 
  factory :todo_item do 
    sequence(:title) {|i| "To-do Item #{i}"}
    status 'Blocking'
    priority 'High'
    deadline Time.now
    description 'Figure out how to make Canto work so we can release v. 0.1.0!'
  end
end