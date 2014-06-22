Given /^I'm viewing my (to\-do list|dashboard)$/ do |page|
  @path = ( page == 'dashboard' ? root_path : tasks_path )
  visit @path
end

Given /^there are (no||\d+) tasks$/ do |number|
  if number == 'no' || number == 0
    Task.count == 0
  else
    @task_list = [] 
    number.to_i.times {|i| @task_list << FactoryGirl.create(:task, title: "Task #{i}")}
  end
end

When /^I click a task's '(.*)' link$/ do |link_text|
  @task = Task.find_by_id(2)
  within('table') do 
    click_link(link_text, href: task_path(@task))
  end
end

When /^I submit the form with the title (.*)$/ do |title|
  fill_in 'task[title]', with: title 
  click_button 'Create Task'
end

Then /^I should not be redirected$/ do 
  expect(current_path).to eql @path
end