When /^I click a task's title$/ do 
  @task = Task.find_by_id(3)
  click_link(@task.title)
end

Then /^I should go to that item's show page$/ do 
  current_path.should eql task_path(@task)
end

Then /^I should see the task's details$/ do 
  within("li#task-#{@task.id}") do 
    find("tr.task-details").should be_visible
  end
end