Transform(/^\d+$/) {|number| number.to_i }

Given(/^there are (\d+|no) tasks$/) do |number|
  number == 'no' ? Task.count == 0 : number.times { FactoryGirl.create(:task) }
end

Given(/^the (\d+)(?:[a-z]{2}) task is complete$/) do |id|
  Task.find(id).update!(complete: true)
end

Then(/^a new task should be created with the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    expect(Task.last.to_hash).to include( 
                                          title: hash['title'],
                                          complete: hash['complete'] == 'true' ? true : false
                                        )
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

Then(/^the (\d+)(?:[a-z]{2}) and (\d+)(?:[a-z]{2}) tasks' indices should be (in|de)creased by (\d+)$/) do |id1, id2, change, amt|
  amt = change == 'de' ? -(amt.to_i) : amt.to_i
  Task.find([id1, id2]).each {|task| expect(task.index - @original_indices[task.id]).to eql amt }
end

Then(/^the (\d+)(?:[a-z]{2}) and (\d+)(?:[a-z]{2}) tasks' indices should not be changed$/) do |id1, id2|
  Task.find([id1, id2]).each {|task| expect(task.index).to eql @original_indices[task.id]}
end

Then(/^the other tasks should be moved up on the list by (\d+)$/) do |increment|
  Task.where.not(id: @task.id).each {|task| expect(@original_indices[task.id] - task.index).to eql increment}
end

Then(/^the tasks' indices should not be changed$/) do
  Task.all.each {|task| expect(task.index).to eql @original_indices[task.id] }
end

Then(/^the task's index should be changed to (\d+)$/) do |number|
  expect(get_changed.index).to eql number
end