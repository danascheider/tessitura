Given(/^there are (\d+|no) users$/) do |number|
  number == 'no' ? User.count == 0 : number.times { FactoryGirl.create(:user) }
end