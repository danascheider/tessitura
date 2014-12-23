Given(/^each organization has (\d+) programs$/) do |count|
  Organization.all.each {|org| FactoryGirl.create_list(:program, count, organization: org) }
end

Then(/^a new program should be created$/) do 
  expect(Program.count).to eql @count + 1
end

Then(/^no new program should be created$/) do
  expect(Program.count).to eql @count
end

Then(/^the new program's (.*) should be (?:"?)(.*?)(?:"?)$/) do |attr,value|
  expect(Program.last.send(attr.to_sym)).to eql value
end