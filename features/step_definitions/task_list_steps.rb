Then(/^the (\d+)(?:[a-z]{2}) task's index should be changed to (\d+)$/) do |id, index_val|
  Task.find(id).index.should eql index_val.to_i
end