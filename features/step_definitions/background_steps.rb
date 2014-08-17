Given(/^the (\d+)(?:[a-z]{2}) user has the following tasks:$/) do |id, tasks|
  tasks.hashes.each do |hash|
    User.find(id).default_task_list.tasks.create(hash)
  end
end

Given(/^the (\d+)(?:[a-z]{2}) user is logged in$/) do |id|
  @user = User.find(id)
  authorize_with @user
end