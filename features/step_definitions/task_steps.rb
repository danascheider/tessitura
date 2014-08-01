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
  expect(get_changed.status).to eql 'complete'
end

Then(/^the (\d+)(.{2}) task should be deleted from the database$/) do |id, ordinal|
  expect(Task.exists?(id: id)).to be false
end

Then(/^the task's position should be changed to (\d+)$/) do |number|
  expect(get_changed.position).to eql number
end