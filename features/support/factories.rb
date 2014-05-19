require 'factory_girl'

FactoryGirl.define do
  factory :user do |user|
    user.username 'testuser'
    user.password 'password'
    user.name 'Test User'
  end
end