Given(/^I am a registered user$/) do 
  @user = User.first
end

Given(/^I am not logged in$/) do 
  visit('/#logout')
end

Given(/^I am logged in$/) do 
  visit('/')

  within(:css, 'ul.top-nav') do 
    find('a.login-link').click 
  end

  within(:css, '#login-form') do 
    fill_in 'Username', with: @user.username 
    fill_in 'Password', with: @user.password
    click_button 'Login'
  end
end

When(/^I navigate to '\/'$/) do
  visit('/')
end

When(/^I navigate to '\/#(.*)'$/) do |path|
  visit("/\##{path}")
end

When(/^I navigate to the Canto mainpage$/) do 
  visit('/')
end

When(/^I submit the login form$/) do 
  fill_in 'Username', with: (@user = User.first).username 
  fill_in 'Password', with: @user.password 
  click_button 'Login'
end

Then(/^I should be redirected to my dashboard$/) do
  pending('Further investigation')
  expect(page).to have_selector('#dashboard-wrapper')
end

Then(/^I should not be redirected to my dashboard$/) do 
  expect(page).not_to have_selector('#dashboard-wrapper')
end

Then(/^I should see the homepage$/) do 
  expect(page).to have_selector('#homepage-wrapper')
end

Then(/^the page status should be (\d+)$/) do |status|
  expect(page.status_code).to eql status.to_i
end

Then(/^there should be a link where I can log in$/) do 
  expect(page).to have_selector('a.login-link')
end