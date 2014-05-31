Given /^there is a task called "(.*)"$/ do |title|
  @task = FactoryGirl.create(:task, title: title)
end

Given /^I am on its edit page$/ do
  visit edit_task_path(@task)
end

When /^I change its title to "(.*)"$/ do |title|
  fill_in 'Title', with: title
  click_button 'Update Task'
end

Then /^I should be routed to the task's show page$/ do 
  current_url.should eql task_url(@task)
end

Then /^the task's title should be changed to "(.*)"$/ do |title|
  # So here's the thing about this. @task is stuck with the title 
  # "Take out the trash", so we have to search for its ID in the 
  # Task class to get the actual current title of that task.
  Task.find_by_id(@task.id).title.should == title
end

Then /^I should see a message that the (.*) was changed$/ do |attribute|
  find('#notice').should have_content("Task was successfully updated")
end
