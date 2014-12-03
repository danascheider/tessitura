Given(/^I am not logged in$/) do 
  visit('/#logout')
end

When(/^I navigate to the Canto mainpage$/) do
  visit('/')
end