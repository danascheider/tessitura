Transform(/^\d+$/) {|number| number.to_i }

Given(/^there are (\d+|no) tasks$/) do |number|
  number == 'no' ? Task.count == 0 : number.times { FactoryGirl.create(:task) }
end

Given(/^the (\d+)(?:[a-z]{2}) task is complete$/) do |id|
  Task.find(id).update!(status: 'complete')
end

Then(/^a new task should be created with the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    hash.each do |key, value|
      expect(Task.last.to_hash).to include(key => value)
    end
  end
end

Then(/^the new task should have the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    hash.each do |key, value|
      expect(Task.last.to_hash).to include(key.intern => value)
    end
  end
end

Given(/^the (\d+)st user's (\d+)rd task is complete$/) do |uid, task_id|
  @user, @task = User.find(uid), @user.tasks[2]
  @task.update(status: 'complete')
end

Then(/^no task should be created$/) do
  @user.tasks.count.should == @user_task_count
end

Then(/^the (first|last) task should (not )?be deleted from the database$/) do |order, negation|
  if negation 
    expect(get_resource(Task, @task_id)).to eql @task
  else
    expect(get_resource(Task, @task_id)).to eql nil
  end
end

Then(/^the task's title should (not )?be changed to "(.*)"$/) do |title, negation|
  if negation
    expect(get_changed_task.title).not_to eql title
  else
    expect(get_changed_task.title).to eql title
  end
end

Then(/^the task's title should not be changed$/) do 
  expect(get_changed_task.title).to eql @task.title
end

Then(/^the task's status should be '(.*)'$/) do |status|
  expect(get_changed_task.status).to eql status
end

Then(/^the task should be marked complete$/) do 
  expect(get_changed_task.status).to eql 'complete'
end

Then(/^the (\d+)(.{2}) task should be deleted from the database$/) do |id, ordinal|
  expect(Task.exists?(id: id)).to be false
end

Then(/^the task's position should be changed to (\d+)$/) do |number|
  expect(get_changed_task.position).to eql number
end