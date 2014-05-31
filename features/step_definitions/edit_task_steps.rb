Given /^there is a task called "(.*)"$/ do |title|
  @task = FactoryGirl.create(:task, title: title)
end

Given /^I am on its edit page$/ do
  visit edit_task_path(@task)
end