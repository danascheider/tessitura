Given(/^I am not logged in$/) do 
  visit('/#logout')
end

When(/^I navigate to the Canto mainpage$/) do
  visit('/')
end

Then(/^I should see the homepage$/) do 
  expect(page).to have_selector('body#homepage')
end

Then(/^there should be a link where I can log in$/) do 
  expect(page).to have_selector('a.login-link')
end