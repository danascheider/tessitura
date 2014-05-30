Given /^I have navigated to the 'New Task' page$/ do
  visit new_task_path
end

When /^I submit the form with the title (.*)$/ do |title|
  fill_in 'Title', with: title 
  click_button 'Create Task'
end

Then /^a new task should be created with the title (.*)$/ do |title|
  Task.count.should == 5 
  Task.last.title.should eql title
end

When /^I submit the form blank$/ do 
  click_button 'Create Task'
end

Then /^no task should be created$/ do
  Task.count.should == 4
end

Then /^I should see a message saying that (.*) is required$/ do |attribute|
  page.should have_css('#error_explanation')
  find('div#error_explanation').should have_content("#{attribute.capitalize} can't be blank")
end