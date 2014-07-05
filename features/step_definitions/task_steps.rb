Given(/^there are the following tasks:$/) do |tasks|
  @original_indices = {}
  tasks.hashes.each do |task|
    task = Task.create(title: task['title'], 
                       complete: task['complete'], 
                       index: task['index'])
    @original_indices[task.id] = task.index
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

Then(/^all the other tasks' indices should be increased by (\d+)$/) do |increase|
  Task.where.not(title: "Call mom").each do |task|
    expect(task.index - @original_indices[task.id]).to eql increase
  end
end

Then(/^the (\d+)(?:[a-z]{2}) and (\d+)(?:[a-z]{2}) tasks' indices should be increased by (\d+)$/) do |id1, id2, increase|
  Task.find([id1, id2]).each {|task| expect(task.index - @original_indices[task.id]).to eql increase }
end

Then(/^the (\d+)(?:[a-z]{2}) and (\d+)(?:[a-z]{2}) tasks' indices should not be changed$/) do |id1, id2|
  Task.find([id1, id2]).each {|task| expect(task.index).to eql @original_indices[task.id]}
end

Then(/^the other tasks should be moved up on the list by (\d+)$/) do |increment|
  puts "TASKS:"
  Task.all.each {|task| puts "#{task.to_hash}\n" }
  puts "ORIGINAL INDICES:"
  @original_indices.each {|key, value| puts "ID #{key} => #{value}"}
  Task.where.not(id: @task.id).each {|task| expect(@original_indices[task.id] - task.index).to eql increment}
end