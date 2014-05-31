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