require 'factory_girl'

FactoryGirl.define do
  factory :user do |user|
    user.username 'testuser'
  end
end