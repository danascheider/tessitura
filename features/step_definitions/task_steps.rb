Given(/^there are the following tasks:$/) do |tasks|
  @tasks = tasks.hashes
  @tasks.each do |task|
    task = Task.create(title: task['title'], complete: task['complete'])
  end
end

Then(/^a new task should be created with the title '(.*)'$/) do |title|
  expect(Task.find_by(title: title)).not_to be_nil
end