When /^I navigate to the dashboard$/ do 
  @path = root_path
  visit @path
end

When /^I mark the "(.*)" task complete$/ do |title|
  @task = Task.find_by(title: title)
  within("#task-#{@task.id}") do 
    click_button ''
  end
end