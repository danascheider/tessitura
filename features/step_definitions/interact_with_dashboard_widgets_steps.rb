Given /^the details of the task are visible$/ do
  within("li#task-#{@task.id}") do 
    find('table div.task-details').should have_content('Status: Incomplete')
  end
end

When /^I mark the "(.*)" task complete$/ do |title|
  @task = Task.find_by(title: title)
  within("li#task-#{@task.id}") do 
    click_button ''
  end
end

When /^I click the '(.*)' link$/ do |link_text|
  within("li#task-#{@task.id}") do 
    click_on(link_text)
  end
end