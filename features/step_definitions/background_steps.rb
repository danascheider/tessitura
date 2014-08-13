Given(/^the (\d+)(?:[a-z]{2}) user has the following tasks:$/) do |id, tasks|
  @user = User.find(id)
  tasks.hashes.each do |hash|
    @user.default_task_list.tasks.create(hash)
  end
end