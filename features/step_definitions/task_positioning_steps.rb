When(/^the client requests to change the (\d+)(?:[a-z]{2}) task's position to (\d+)$/) do |id, pos|
  user = User[Task[id].owner_id]
  @positions = user.tasks.map {|t| [t.id, t.position] }
  authorize_with user
  put "/tasks/#{id}", {:position => pos}.to_json
end

When(/^the client requests to delete task (\d+)$/) do |id|
  user = User[Task[id].owner_id]
  @positions = user.tasks.map {|t| [t.id, t.position] }
  authorize_with user 
  delete "/tasks/#{id}"
end

When(/^the task in position (\d+) on the (\d+)(?:[a-z]{2}) user's list is marked complete$/) do |position, id|
  user = User[id]
  @positions = user.tasks.map {|t| [t.id, t.position] }
  @task = user.tasks.find {|t| t.position === position }
  @task.update(status: 'Complete')
end

Then(/^its position should be changed to (\d+)$/) do |position|
  expect(@task.position).to eql position.to_i
end

Then(/^the position of the new task should be (\d+)$/) do |position|
  expect(Task.last.position).to eql position.to_i
end

Then(/^the position of task (\d+) should be (\d+)$/) do |id, position|
  expect(Task[id].position).to eql position.to_i
end

Then(/^the positions of tasks (.*) should be (.*)$/) do |ids, positions|

  # I have no bloody idea why this won't work if I put it in a transform.
  # But it won't. I've tried different things for hours. I recommend against
  # trying any more.

  ids = ids.gsub(/[^\d+|\,]/, '').split(',').map {|num| num.to_i }
  positions = positions.gsub(/[^\d+|\,]/, '').split(',').map {|num| num.to_i }
  ids.each {|id| expect(Task[id].position).to eql(positions[ids.index(id)]) }
end

Then(/^the positions of tasks (.*) should not be changed$/) do |ids|
  ids = ids.gsub(/[^\d+|\,]/, '').split(',').map {|num| num.to_i }
  ids.each {|id| expect(Task[id].position).to eql(@positions.to_h[id]) }
end

Then(/^the (\d+)(?:[a-z]{2}) user\'s other tasks should have their positions incremented$/) do |uid|
  positions = (User[uid].tasks - [Task.last]).map {|task| task.position }

  # Positions are expected to be [4, 3, 2] instead of [2, 3, 4] because tasks are 
  # instantiated at position 1, so tasks with higher IDs will have lower positions
  # (i.e., will be closer to the top of the list)

  expect(positions).to eql([4, 3, 2])
end

