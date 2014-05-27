FactoryGirl.define do 
  factory :user do 
    username "frank"
    password_digest "mypasswd1"
    email "frank@example.com"
  end
end