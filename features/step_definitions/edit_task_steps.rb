Given /^there is a task called "(.*)"$/ do |title|
  @task = FactoryGirl.create(:task, title: title)
end

### Scenario 1

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
  # @task itself doesn't get changed when Capybara submits
  # the form (only the task object with its ID does). 
  Task.find_by_id(@task.id).title.should == title
end

Then /^I should see a message that the (.*) was changed$/ do |attribute|
  find('#notice').should have_content("Task was successfully updated")
end

### Scenario 2

When /^I click the checkbox next to the "(.*)" task$/ do |title|
  @task = Task.find_by(title: title)
  check("complete-task#{@task.id}")
end

Then /^the task should disappear from the list$/ do
  page.should_not have_css("#task-#{@task.id}")
end

Then /^the task's 'complete' attribute should be (true|false)$/ do |value|
  @task.complete.should eql value
end