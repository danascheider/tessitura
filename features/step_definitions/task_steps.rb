Given(/^there are the following tasks:$/) do |tasks|
  tasks.hashes.each do |task|
    task = Task.create(title: task['title'], 
                       complete: task['complete'], 
                       index: task['index'])
  end
end

Then(/^a new task should be created with the title '(.*)'$/) do |title|
  expect(Task.find_by(title: title)).not_to be_nil
end

Then(/^no task should be created$/) do
  Task.count.should === @task_count
end

Then(/^the task's title should be changed to '(.*)'$/) do |title|
  expect(get_changed.title).to eql title
end

Then(/^the task's title should not be changed$/) do 
  expect(get_changed.title).to eql @task.title
end

Then(/^the task should be marked complete$/) do 
  expect(get_changed.complete).to be true
end

Then(/^the (\d+)(.{2}) task should be deleted from the database$/) do |id, ordinal|
  expect(Task.exists?(id: id)).to be false
end

Then(/^a task called "(.*?)" should be created with index (\d+)$/) do |title, index|
  expect(Task.exists?(title: title, index: index))
end