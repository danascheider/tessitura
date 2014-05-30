### All Scenarios

Given /^there are (no||\d+) tasks$/ do |number|
  if number == 'no' || number == 0
    Task.count == 0
  else
    @task_list = [] 
    number.to_i.times {|i| @task_list << FactoryGirl.create(:task, title: "Task #{i}")}
  end
end


When /^I navigate to the to\-do list$/ do 
  visit tasks_path
end

### Scenario 1

Then /^I should not see any tasks$/ do 
  find('body').should_not have_css('#todo_list')
end

Then /^I should see a message stating I have no tasks$/ do 
  find('p').should have_content('No tasks!')
end

Then /^I should see a link to create a new task$/ do 
  find('p>a').should have_content('Create one')
end


### Scenario 2

Then /^I should see a list of all the tasks$/ do 
  @task_list.each do |task|
    find('table').should have_content(task.title)
  end
end