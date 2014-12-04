Given(/^I am not logged in$/) do 
  visit('/#logout')
end

Given(/^I am logged in$/) do 
  @user = User.first
  visit('/#login')
  fill_in 'Username', with: @user.username
  fill_in 'Password', with: @user.password
  click_button 'Login'
end

When(/^I navigate to '\/'$/) do
  visit('/')
end

When(/^I navigate to '\/#login'$/) do
  visit('/#login')
end

When(/^I submit the login form$/) do 
  fill_in 'Username', with: (@user = User.first).username 
  fill_in 'Password', with: @user.password 
  click_button 'Login'
end

Then(/^I should be redirected to my dashboard$/) do
  expect(page).to have_selector('body#dashboard')
  expect(page).not_to have_selector('body#homepage')
end

Then(/^I should see the homepage$/) do 
  expect(page).to have_selector('body#homepage')
end

Then(/^there should be a link where I can log in$/) do 
  expect(page).to have_selector('a.login-link')
end