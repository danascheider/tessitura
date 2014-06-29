Given(/^there are the following tasks:$/) do |tasks|
  @tasks = tasks.hashes
  @tasks.each do |task|
    task = Task.create(title: task['title'], complete: task['complete'])
  end
end