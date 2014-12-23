Given(/^each organization has (\d+) programs$/) do |count|
  Organization.all.each {|org| FactoryGirl.create_list(:program, count, organization: org) }
end

Given(/^organization (\d+) has no programs$/) do |id|
  @organization = Organization[id] || FactoryGirl.create(:organization, id: id)
  @organization.programs === []
end

Given(/^program (\d+) doesn't exist$/) do |id|
  Program[id] === nil || Program[id].destroy
end

Given(/^there are no programs$/) do 
  Program.each {|p| p.destroy }
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

Then(/^the program should not be changed$/) do
  expect(@program.values).to eql(@program.refresh.values)
end

Then(/^the program's (.*) should be (\d+)$/) do |attr, val|
  expect(@program.refresh.send(attr.to_sym)).to eql val
end