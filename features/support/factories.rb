require 'factory_girl'

FactoryGirl.define do 
  factory :task do 
    title 'MyString'
    complete false
    index 1
  end
end