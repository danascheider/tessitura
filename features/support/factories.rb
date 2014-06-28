require 'factory_girl'

# FIX ME: Obviously we have some serious repetition going on here 
#         with the spec factories. This needs to be cleaned up but
#         frankly isn't my top priority right now.

FactoryGirl.define do 
  factory :task do 
    title 'MyString'
  end
end