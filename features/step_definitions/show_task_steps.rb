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