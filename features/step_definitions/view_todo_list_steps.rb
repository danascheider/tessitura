### All Scenarios

When /^I navigate to the to\-do list$/ do 
  visit tasks_path
end

### Scenario 1

Then /^I should not see any tasks$/ do 
  find('body').should_not have_css('#todo_list')
end

Then /^I should see a message stating I have no tasks$/ do 
  find('p.notice').should have_content('No tasks!')
end

Then /^I should see a link to create a new task$/ do 
  find('p>a').should have_content('Create one')
end


### Scenario 2

Then /^I should see a list of all the tasks$/ do 
  @task_list.each do |task|
    find('ul.list-group').should have_content(task.title)
  end
end

Given /^the tasks are incomplete $/ do 
  @task_list.each do |task|
    task.update(complete: false)
  end
end

### Scenario 3
Given /^one of the tasks is completed$/ do 
  (@done_task = @task_list.first).update(complete: true)
end

Then /^I should not see the completed task on the list$/ do 
  find('ul.list-group').should_not have_content(@done_task.title)
end