Given(/^the following organizations:$/) do |json|
  array = JSON.parse(json)
  array.each {|hash| FactoryGirl.create(:organization, hash)}
end