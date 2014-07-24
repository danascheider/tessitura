Given(/^there are (\d+|no) users$/) do |number|
  number == 'no' ? User.count == 0 : number.times { FactoryGirl.create(:user) }
end

# ADMIN STEPS
# ===========

Then(/^the user named '(\w+) (\w+)' should be an admin$/) do |first, last|
  User.find_by(first_name: first, last_name: last)[0].should be_admin
end

# USER CREATION
# =============

Then(/^a user named '(\w+) (\w+)' should be created$/) do |first, last|
  User.find_by(first_name: first, last_name: last).should_not eql nil
end