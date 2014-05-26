Given /^I am a user$/ do
  @user = FactoryGirl.create(:user)
end

Given /^I am (not)? logged in$/ do |negation|
  @user.logged_in = true unless negation
end

When /^I navigate to the Canto homepage$/ do 
  visit root_path
end