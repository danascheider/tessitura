Transform(/^\d+$/) {|number| number.to_i }
Transform(/^(\d+)([a-z]{2})$/) {|num, ordinal| num.to_s.to_i }

Given(/^the (\d+)(?:[a-z]{2}) task is incomplete$/) do |id|
  Task[id].update({status: 'In Progress'})
end

Given(/^the (\d+)(?:[a-z]{2}) task is backlogged$/) do |id|
  Task[id].update({backlog: true})
end

Then(/^no task should be created$/) do
  expect(User[@user.id].tasks.count).to eql @user_task_count
end

Then(/^the existent tasks should not be updated$/) do
  # This is only used in one step - update_task.feature:66
  [1, 2].each do |id|
    expect(Task[id].title).not_to eql(@tasks[id - 1]['title'])
  end
end

Then(/^the (\d+)(?:[a-z]{2}) task should not be backlogged$/) do |id|
  puts Task[id].to_h
  expect(Task[id].backlog).to be_falsey
end

Then(/^the new task should have the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    hash.each do |key, value|
      value = value.to_i if (/^\d+$/).match(value)
      expect(Task.last.to_hash).to include(key.intern => value)
    end
  end
end

Then(/^the task's title should (not )?be changed to (.*)$/) do |neg, title|
  expect(Task[@task.id].title === title).to neg ? be_falsey : be_truthy
end

Then(/^the task's title should not be changed$/) do 
  expect(Task[@task.id].title).to eql @task.title
end

Then(/^the tasks' positions should( not)? be changed$/) do |neg|
  @tasks.each do |hash| 
    task = Task[hash['id']]
    expect(task.position).to eql hash['position'] unless neg
  end
end

Then(/^the (\d+[a-z]{2}) task should( not)? be deleted from the database$/) do |id, neg|
  expect(Task[id]).to neg ? be_truthy : be_falsey
end