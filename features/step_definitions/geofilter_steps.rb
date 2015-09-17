Given(/^the following organizations:$/) do |json|
  array = JSON.parse(json)
  array.each {|hash| FactoryGirl.create(:organization, hash)}
end

Then(/^the response should indicate the filter was invalid$/) do
  expect(last_response.body).to eql 'Error: Please include state or postal code.'
end