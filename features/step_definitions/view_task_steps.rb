Then /^I should go to that item's show page$/ do 
  current_path.should eql task_path(@task)
end

Then /^I should see the task's title and status$/ do 
  find('table').should have_content(@task.title)
  status = if @task.complete? then 'Complete'; else 'Incomplete'; end
  find('table').should have_content(status)
end