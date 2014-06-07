When /^I navigate to the dashboard$/ do 
  visit root_path
end

When /^I mark the "(.*)" task complete$/ do |title|
  @task = Task.find_by(title: title)
  within("#task-#{@task.id}") do 
    click_on 'Mark Complete'
  end
end

Then /^I should not be redirected$/ do 
  expect(current_path).to eql root_path
end