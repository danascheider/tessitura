When /^I mark the "(.*)" task complete$/ do |title|
  @task = Task.find_by(title: title)
  within("li#task-#{@task.id}") do 
    click_button ''
  end
end