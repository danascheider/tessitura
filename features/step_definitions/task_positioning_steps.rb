Then(/^the position of the new task should be (\d+)$/) do |position|
  expect(Task.last.position).to eql position.to_i
end

Then(/^the position of task (\d+) should be (\d+)$/) do |id, position|
  expect(Task[id].position).to eql position.to_i
end

Then(/^the positions of tasks (.*) should be (.*)$/) do |ids, positions|
  ids = ids.gsub(/[^\d+|\,]/, '').split(',').map {|num| num.to_i }
  positions = positions.gsub(/[^\d+|\,]/, '').split(',').map {|num| num.to_i }

  ids.each {|id| expect(Task[id].position).to eql(positions[ids.index(id)]) }
end

Then(/^the (\d+)(?:[a-z]{2}) user\'s other tasks should have their positions incremented$/) do |uid|
  positions = (User[uid].tasks - [Task.last]).map {|task| task.position }

  # Positions are expected to be [4, 3, 2] instead of [2, 3, 4] because tasks are 
  # instantiated at position 1, so tasks with higher IDs will have lower positions
  # (i.e., will be closer to the top of the list)

  expect(positions).to eql([4, 3, 2])
end

