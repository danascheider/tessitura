require 'factory_girl'

FactoryGirl.define do
  factory :user do |user|
    user.username 'testuser'
    user.password 'password'
    user.name 'Test User'
  end

  factory :todo_item do |item|
    item.title 'Dummy item'
    item.status 'New'
    association :user
  end
end