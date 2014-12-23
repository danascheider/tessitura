Then(/^a new program should be created$/) do 
  expect(Program.count).to eql @count + 1
end