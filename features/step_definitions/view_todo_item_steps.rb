### Scenario 1: To-do list is empty ###

Given /^my to\-do list is empty$/ do 
  assert_empty(@user.todo_items)
end

When /^I navigate to my to\-do list$/ do
  visit user_todo_items_path(@user.id)
end

Then /^I should see a message that I have no to\-do items$/ do 
  find('body').should have_content("No to-do items!")
end

Then /^I should see a link to create a new to\-do item$/ do 
  find_link('Create one').should_not be_nil
end

### Scenario 2: To-do list has 3 items ###

Given /^I have (\d)+ to\-do items$/ do |number|
  @user.todo_items.count == number
end

Then(/^there should be (\d+) to\-do items listed$/) do |arg1|
  find('#item-3').should have_content(@user.todo_items.last.title)
end
