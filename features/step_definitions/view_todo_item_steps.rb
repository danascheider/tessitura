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

Given /^the to\-do items are called "(.*)", "(.*)", and "(.*)"$/ do |title1, title2, title3|
  item1 = FactoryGirl.create(:todo_item, title: title1, user_id: @user.id)
  item2 = FactoryGirl.create(:todo_item, title: title2, user_id: @user.id)
  item3 = FactoryGirl.create(:todo_item, title: title3, user_id: @user.id)
  @titles = [title1, title2, title3]
end

Then(/^all of the to\-do items should be listed$/) do
  @titles.each do |title|
    find('body').should have_content(title)
  end
end