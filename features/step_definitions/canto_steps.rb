Given /^I'm viewing my to\-do list$/ do 
  visit tasks_path
end

When /^I click a task's '(.*)' link$/ do |link_text|
  @task = Task.find_by_id(2)
  within('table') do 
    click_link(link_text, href: task_path(@task))
  end
end

When /^I submit the form with the title (.*)$/ do |title|
  fill_in 'Title', with: title 
  click_button 'Create Task'
end