Given(/^there are the following tasks:$/) do |tasks|
  tasks.hashes.each do |task|
    FactoryGirl.create(:task, title: task['title'])
  end
end