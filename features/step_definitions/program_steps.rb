Then(/^a new program should be created$/) do 
  expect(Program.count).to eql @count + 1
end

Then(/^the new program's (.*) should be (?:"?)(.*?)(?:"?)$/) do |attr,value|
  expect(Program.last.send(attr.to_sym)).to eql value
end