### Scenario 1: To-do list is empty ###

Given /^I have (no|\d+) to\-do items$/ do |number|
  if number == 'no' || (number = number.to_i) == 0
    (@todo_list = @user.todo_items.to_a).length == 0
  else
    @todo_list = FactoryGirl.create_list(:todo_item, number, user_id: @user.id)
  end
  @todo_list
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

Then(/^I should see all of my to\-do items$/) do
  unless @todo_list.length == 0
    @todo_list.each do |todo_item|
      find('body').should have_content(todo_item.title)
    end
  end
end

Then(/^I should not see anyone else\'s to\-do items$/) do 
  page.should have_css(".todo_item", count: @todo_list.length )
end

### Scenario 3: Some tasks are complete
Given /^(\d+) of them have been marked (.*)$/ do |number, status|
  for i in 0..(number.to_i - 1)
    @todo_list[i].status = 'Complete'
  end
end

Then /^I shouldn\'t see the items that have been marked '(.*)'$/ do |status|
  @todo_list.each do |todo_item|
    unless TodoItem.incomplete.include? todo_item
      find('body').should_not have_content(todo_item.title)
    end
  end
end

### Scenario 4: User marks task complete
When /^I click the '(.*)' link on the first to-do item$/ do |link|
  pending
  within("todo_item_#{@todo_list.first}") do 
    click_on('Mark Completed')
  end
end

Then /^the status of the first to-do item should be (.*)$/ do |status|
  expect(@todo_list.first.status).to eql('Complete')
end

Then /^the first to-do item should disappear from the list$/ do
  @todo_list.first.should_not be_visible
end