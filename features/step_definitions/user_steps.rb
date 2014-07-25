Given(/^there are (\d+|no) users$/) do |number|
  number == 'no' ? User.count == 0 : number.times { FactoryGirl.create(:user) }
end

# ADMIN STEPS
# ===========

Then(/^the user named '(\w+) (\w+)' should be an admin$/) do |first, last|
  User.find_by(first_name: first, last_name: last).should be_admin
end

Then(/^the (\d+)(?:[a-z]{2}) user should (not )?be an admin$/) do |id, neg|
  User.find(id).should be_admin unless neg
end

# USER CREATION
# =============

Then(/^a user named '(\w+) (\w+)' should be created$/) do |first, last|
  User.find_by(first_name: first, last_name: last).should_not eql nil
end