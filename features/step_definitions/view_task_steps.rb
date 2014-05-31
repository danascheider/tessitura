Given /^I'm viewing my to\-do list$/ do 
  visit tasks_path
end

When /^I click a task's '(.*)' link$/ do |link_text|
  @task = Task.find_by_id(2)
  within('table') do 
    click_link(link_text, href: task_path(@task))
  end
end

Then /^I should go to that item's show page$/ do 
  current_path.should eql task_path(@task)
end

Then /^I should see the task's title and status$/ do 
  find('table').should have_content(@task.title)
  status = if @task.complete? then 'Complete'; else 'Incomplete'; end
  find('table').should have_content(status)
end