require 'factory_girl'

FactoryGirl.define do
  factory :user do |f|
    f.username 'testuser'
  end
end