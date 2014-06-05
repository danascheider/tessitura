When /^I navigate to the dashboard$/ do 
  visit dashboard_path
end

When /^I mark the "(.*)" task complete$/ do |title|
  @task = Task.find_by(title: title)
  form_id = "#task-#{@task.id}"
  within(form_id) do 
    click_on 'Mark Complete'
  end
end