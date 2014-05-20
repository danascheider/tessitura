### Scenario 1: To-do list is empty ###

Given /^I have (no|\d+) to\-do items$/ do |number|
  if number == 'no' || number == 0
    @user.todo_items.length == 0
  else
    number = number.to_i
    i = 1
    number.times do 
      FactoryGirl.create(:todo_item, title: "My Task #{i}", user_id: @user.id)
      i += 1
    end
  end
  @todo_list = @user.todo_items.to_a
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
  page.should have_css(".todo-list-item", count: @todo_list.length )
end

### Scenario 3: Some tasks are complete
Given /^(\d+) of them have been marked (.*)$/ do |number, status|
  number = number.to_i
  for i in 0..(number - 1)
    @todo_list[i].status = 'Complete'
  end
end

Then /^I shouldn\'t see the items that have been marked '(.*)'$/ do |status|
  @todo_list.each do |todo_item|
    if todo_item.status == 'Complete'
      find('body').should_not have_content(todo_item.title)
    end
  end
end