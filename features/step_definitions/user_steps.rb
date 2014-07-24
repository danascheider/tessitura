Given(/^there are (\d+|no) users$/) do |number|
  number == 'no' ? User.count == 0 : number.times { FactoryGirl.create(:user) }
end

# ADMIN STEPS
# ===========

Then(/^the user named '(\w+) (\w+)' should be an admin$/) do |first, last|
  @user = User.find_by(first_name: first, last_name: last)
  @user.should be_admin
end