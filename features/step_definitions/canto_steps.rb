Given /^there are (no||\d+) tasks$/ do |number|
  if number == 'no' || number == 0
    Task.count == 0
  else
    @task_list = [] 
    number.to_i.times {|i| @task_list << FactoryGirl.create(:task, title: "Task #{i}")}
  end
end