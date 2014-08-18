Then(/^the JSON response should include all the (\d+)nd user's tasks$/) do |id|
  expect(response_body).to eql User.find(id).tasks.to_json
end

Then(/^the JSON response should include all the users$/) do 
  expect(response_body).to eql User.all.to_json
end

Then(/^the JSON response should include task (\d+)$/) do |id|
  response_body.should === [get_resource(Task, id).to_hash].to_json
end

Then(/^the JSON response should include (?:only )?the (\d+)(?:[a-z]{2}) task$/) do |id|
  response_body.should === get_resource(Task, id).to_json
end

Then(/^the JSON response should include tasks (\d+) and (\d+)$/) do |id1, id2|
  arr = [get_resource(Task, id1).to_hash, get_resource(Task, id2).to_hash]
  response_body.should === arr.to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) user's last (\d+) tasks$/) do |id, qty|
  arr = Task.where(owner_id: id).last(qty).to_a.map! {|task| task.to_hash }
  response_body.should === arr.to_json
end

Then(/^the JSON response should include the (\d+)(?:[a-z]{2}) user's profile information$/) do |id|
  expect(response_body).to eql User.find(id).to_json
end

Then(/^the response should not include any tasks without a(?:n?) (.*)$/) do |attribute|
  excluded = Set.new(Task.where(attribute.to_sym => nil))
  expect(Set.new(parse_json(response_body)).intersect?(excluded)).to be_falsey
end

Then(/^the response should not include any data$/) do 
  ok_values = [nil, '', 'null', false, "Authorization Required\n"]
  expect(ok_values).to include response_body
end

Then(/^the response should indicate the (?:.*) was (not )?saved successfully$/) do |negation|
  expect(response_status).to eql negation ? 422 : 201
end

Then(/^the response should indicate the (?:.*) was (not )?updated successfully$/) do |negation|
  expect(response_status).to eql negation ? 422 : 200
end

Then(/^the response should indicate the request was unauthorized$/) do
  expect(response_status).to eql 401
end

Then(/^the response should return status (\d{3})$/) do |status|
  expect(response_status).to eql status
end

Then(/^the response should indicate the (?:.*) was deleted successfully$/) do
  expect(response_status).to eql 204
end

Then(/^the response should indicate the (?:.*) was not found$/) do
  expect(response_status).to eql 404
end