Given /^I am a user$/ do
  @user = FactoryGirl.create(:user)
end

Given /^I am (not)? logged in$/ do |negation|
  @user.logged_in = true unless negation
end