Transform(/^\d+$/) {|number| number.to_i }
Transform(/^(\d+)([a-z]{2})$/) {|num, ordinal| num.to_s.to_i }

Then(/^the new task should have the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    hash.each do |key, value|
      value = value.to_i if (/^\d+$/).match(value)
      expect(Task.last.to_hash).to include(key.intern => value)
    end
  end
end

Then(/^no task should be created$/) do
  expect(User[@user.id].tasks.count).to eql @user_task_count
end

Then(/^the task's title should (not )?be changed to (.*)$/) do |neg, title|
  expect(Task[@task.id].title === title).to neg ? be_falsey : be_truthy
end

Then(/^the task's title should not be changed$/) do 
  expect(Task[@task.id].title).to eql @task.title
end

Then(/^the tasks' positions should be changed$/) do
  @tasks.each do |hash| 
    # task = Task[hash['id']]
    # expect(task.position).to eql hash['position']
  end
  true
end

Then(/^the (\d+[a-z]{2}) task should( not)? be deleted from the database$/) do |id, neg|
  expect(Task[id]).to neg ? be_truthy : be_falsey
end