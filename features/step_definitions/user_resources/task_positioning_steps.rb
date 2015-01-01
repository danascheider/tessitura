Given(/^tasks with the following attributes:$/) do |attributes|
  attributes.hashes.each {|hash| Task[hash.delete('id')].update(hash) }
end

Given(/^tasks (\d+) and (\d+) are complete$/) do |id1, id2|
  @positions = {}
  [Task[id1], Task[id2]].each {|t| t.update(status: 'Complete') }
  Task.where(owner_id: 3).each {|t| @positions[t.id] = t.position }
end

Given(/^tasks (\d+) and (\d+) are backlogged$/) do |id1, id2|
  @positions = {}
  User[Task[id2].owner_id].tasks.each {|t| @positions[t.id] = t.position }
  [Task[id1], Task[id2]].each {|t| t.update(backlog: true) }
end

When(/^the client requests to change the (\d+)(?:[a-z]{2}) task's position to (\d+)$/) do |id, pos|
  @positions = {}
  (user = User[Task[id].owner_id]).tasks.each {|t| @positions[t.id] = t.position }
  authorize_with user
  put "/tasks/#{id}", {:position => pos}.to_json
end

When(/^the client requests to delete task (\d+)$/) do |id|
  @positions = {}
  (user = User[Task[id].owner_id]).tasks.each {|t| @positions[t.id] = t.position }
  authorize_with user 
  delete "/tasks/#{id}"
end

When(/^task (\d+) is marked complete$/) do |id|
  (@task = Task[id]).update(status: 'Complete')
end

When(/^task (\d+) is backlogged$/) do |id|
  (@task = Task[id]).update(backlog: true)
end

When(/^the task in position (\d+) on the (\d+)(?:[a-z]{2}) user's list is marked complete$/) do |position, id|
  @positions = {}
  User[id].tasks.map {|t| @positions[t.id] = t.position }
  @task = User[id].tasks.find {|t| t.position === position }
  @task.update(status: 'Complete')
end

When(/^the task in position (\d+) on the (\d+)(?:[a-z]{2}) user's list is backlogged$/) do |position, id|
  @positions = {} 
  User[id].tasks.each {|t| @positions[t.id] = t.position }
  @task = User[id].tasks.find {|t| t.position === position }
  @task.update(backlog: true)
end

When(/^the task in position (\d+) on the (\d+)(?:[a-z]{2}) user's list is updated with:$/) do |position, id, attributes|
  @task = User[id].tasks.find {|t| t.position === position }
  @positions = {}
  User[id].tasks.map {|t| @positions[t.id] = t.position }
  @task.update(attributes.hashes.first)
end

Then(/^its position should be changed to (\d+)$/) do |position|
  expect(@task.position).to eql position.to_i
end

Then(/^the position of the new task should be (\d+)$/) do |position|
  @task = Task.last
  expect(Task.last.position).to eql position.to_i
end

Then(/^the position of task (\d+) should be (\d+)$/) do |id, position|
  dump_user_tasks(3)
  expect(Task[id].position).to eql position.to_i
end

Then(/^the positions of tasks (.*) should be (.*)$/) do |ids, positions|

  # I have no bloody idea why this won't work if I put it in a transform.
  # But it won't. I've tried different things for hours. I recommend against
  # trying any more.

  ids = ids.gsub(/[^\d+|\,]/, '').split(',').map(&:to_i)
  positions = positions.gsub(/[^\d+|\,]/, '').split(',').map(&:to_i)
  ids.each {|id| expect(Task[id].position).to eql(positions[ids.index(id)]) }
end

Then(/^the positions of tasks (.*) should not be changed$/) do |ids|
  ids = ids.gsub(/[^\d+|\,]/, '').split(',').map(&:to_i)
  ids.each {|id| expect(Task[id].position).to eql(@positions[id]) }
end

Then(/^the (\d+)(?:[a-z]{2}) user\'s other tasks should have their positions incremented$/) do |uid|

  # This applies to the first scenario, where the tasks are those of user 1 and user 1
  # creates a new task. Other scenarios dealing with positioning should be sure that 
  # `@positions` is defined in a step preceding this one.

  @positions ||= {3 => 1, 2 => 2, 1 => 3}
  positions = {}
  (User[uid].tasks).each {|t| positions[t.id] = t.position unless t.id === @task.id }
  @positions.reject! {|k,v| k === @task.id }
  @positions.each {|k,v| @positions[k] = v + 1 }

  # Positions are expected to be [4, 3, 2] instead of [2, 3, 4] because tasks are 
  # instantiated at position 1, so tasks with higher IDs will have lower positions
  # (i.e., will be closer to the top of the list)

  expect(positions).to eql @positions
end

