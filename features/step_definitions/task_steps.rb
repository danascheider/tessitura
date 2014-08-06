Transform(/^\d+$/) {|number| number.to_i }
Transform(/^(\d+)([a-z]{2})$/) {|num, ordinal| num.to_s.to_i }

Then(/^the new task should have the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    hash.each do |key, value|
      expect(Task.last.to_hash).to include(key.intern => value)
    end
  end
end

Given(/^the (\d+[a-z]{2}) task is complete$/) do |task_id|
  @task = get_resource(Task, task_id)
  @task.update!(status: 'complete')
end

Then(/^no task should be created$/) do
  expect(get_changed_user.tasks.count).to eql @user_task_count
end

Then(/^the task's title should (not )?be changed to (.*)$/) do |neg, title|
  expect(get_changed_task.title == title).to neg ? be_falsey : be_truthy
end

Then(/^the task's title should not be changed$/) do 
  expect(get_changed_task.title).to eql @task.title
end

Then(/^the task's status should be (.*)$/) do |status|
  expect(get_changed_task.status).to eql status
end

Then(/^the task should be marked complete$/) do 
  expect(get_changed_task.status).to eql 'complete'
end


Then(/^the (\d+[a-z]{2}) task should( not)? be deleted from the database$/) do |id, neg|
  expect(Task.exists?(id: id)).to neg ? be_truthy : be_falsey
end

Then(/^the task's position should be changed to (\d+)$/) do |number|
  expect(get_changed_task.position).to eql number
end