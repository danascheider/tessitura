Then(/^a new task should be created on the (\d+)(?:[a-z]{2}) user\'s task list$/) do |uid|
  expect(User[uid].tasks.count - @user_task_count).to eql 1
end