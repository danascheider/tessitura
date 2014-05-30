Given /^I have navigated to the 'New Task' page$/ do
  visit new_task_path
end

When /^I submit the form with the title (.*)$/ do |title|
  fill_in 'Title', with: title 
end