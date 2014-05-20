When /^I navigate to my new to-do item page$/ do
  visit new_user_todo_item_path(@user.id)
end

### Test form submission & validation

### These two tests go together and need refactoring so they can be separated ###
When /^I submit the filled-out form$/ do 
  fill_in('Title', {with: "My To-Do Item"})
  fill_in('Description', {with: "Test to-do items with Cucumber & Capybara"})
  choose('todo_item_priority_urgent')
  select('Blocking', {from: 'todo_item_status'})
  click_button('Create Todo item')
end

Then /my last to-do item should have the information from the form$/ do 
  todo_item = TodoItem.where(user: @user).last
  expect(todo_item.title).to eql "My To-Do Item"
  expect(todo_item.description).to eql("Test to-do items with Cucumber & Capybara")
  expect(todo_item.priority).to eql('Urgent')
  expect(todo_item.status).to eql('Blocking')
end
### End grouped tests ###

When /^I submit the form with no title$/ do 
  fill_in('Description', {with: "Test to-do items with Cucumber & Capybara"})
  choose('todo_item_priority_urgent')
  select('Blocking', {from: 'todo_item_status'})
  click_button('Create Todo item')
end

When /^I submit the form with only a title$/ do 
  fill_in('Title', {with: "Take out the trash"})
  click_button('Create Todo item')
end

Then /^I should see a message that the to-do item was created$/ do 
  find('#notice').should have_content("Todo item was successfully created")
end

Then /^I should see a message that the title field is required$/ do 
  find("#error_explanation").should_not be_nil
end