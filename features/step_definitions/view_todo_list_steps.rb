Given /^there are no tasks$/ do 
  Task.count == 0
end

When /^I navigate to the to\-do list$/ do 
  visit tasks_path
end

Then /^I should not see any tasks$/ do 
  find('body').should_not have_css('#todo_list')
end

Then /^I should see a message stating I have no tasks$/ do 
  find('body').should have_content('No tasks!')
end

Then /^I should see a link to create a new task$/ do 
  find('a').should have_content('Create one')
end