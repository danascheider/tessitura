Given(/^there are the following tasks:$/) do |tasks|
  @tasks = tasks.hashes
  @tasks.each do |task|
    task = Task.create(title: task['title'], complete: task['complete'])
  end
end

Then(/^a new task should be created with the title '(.*)'$/) do |title|
  expect(Task.find_by(title: title)).not_to be_nil
end

Then(/^no task should be created$/) do
  Task.count.should === @task_count
end

Then(/^the task's title should be changed to '(.*)'$/) do |title|
  expect(Task.find(@task.id).title).to eql title
end

Then(/^the task should be marked complete$/) do 
  expect(Task.find(@task.id).complete).to be true
end

Then(/^the task's title should not be changed$/) do 
  expect(Task.find(@task.id).title).to eql @task.title
end