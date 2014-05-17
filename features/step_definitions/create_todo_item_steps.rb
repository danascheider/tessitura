Given /^I am a user$/ do
  @user = FactoryGirl.create(:user)
end

When /^I navigate to my new to-do item page$/ do
  visit new_user_todo_item_path(@user.id)
end

When /^I submit the filled-out form$/ do 
  fill_in('Title', {with: "My To-Do Item"})
  fill_in('Description', {with: "Test to-do items with Cucumber & Capybara"})
  choose('todo_item_priority_urgent')
  select('Blocking', {from: 'todo_item_status'})
  click_button('Create Todo item')
end

When /^I submit the form with no title$/ do 
  fill_in('Description', {with: "Test to-do items with Cucumber & Capybara"})
  choose('todo_item_priority_urgent')
  select('Blocking', {from: 'todo_item_status'})
  click_button('Create Todo item')
end  