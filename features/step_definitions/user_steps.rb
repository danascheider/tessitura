Given(/^there are (\d+|no) users$/) do |number|
  # @user_count is invoked in 'no user should be created', below
  number == 'no' ? User.count == 0 : number.times { FactoryGirl.create(:user) }
  @user_count = User.count
end

Given(/^there (?:are users|is a user) with the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    FactoryGirl.create(:user, hash)
  end
  @admin = User.where(admin: true).first 
  @user = User.find(2)
end

Given(/^there is a user with (\d+) tasks$/) do |count|
  FactoryGirl.create(:task_list_with_tasks, tasks_count: count)
end

Given(/^each user has (\d+) tasks$/) do |number|
  User.all.each do |user|
    FactoryGirl.create(:task_list_with_tasks, tasks_count: number, user_id: user.id)
  end
end

# ADMIN STEPS
# ===========

Then(/^the user should be an admin$/) do
  @user.should be_admin
end

Then(/^the (\d+)(?:[a-z]{2}) user should (not|yes)?(?: )?be an admin$/) do |id, neg|
  expect(User.find(id).admin?).to (neg == 'not') ? be_falsey : be_truthy
end

# USER CREATION STEPS
# ===================

Then(/^a new user should be created with the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    User.last.to_hash.each do |key, value|
      value = value == true ? 'true' : value
      expect(value).to eql hash[key.to_s] if hash.has_key? key.to_s
    end
  end
end

Then(/^no user should be created$/) do 
  User.count.should == @user_count
end

# USER UPDATE STEPS
# =================
Then(/^the (\d+)(?:[a-z]{2}) user's (.*) should be changed to (.*)$/) do |id, attr, value|
  @user = get_resource(User, id)
  expect(@user.to_hash[attr.intern]).to eql value
end

Then(/^the user's (.*) should not be changed$/) do |attr|
  expect(get_changed_user.to_hash[attr.intern]).to eql @user.to_hash[attr.intern]
end

# Delete User
# ===========
Then(/^the (\d+)(?:[a-z]{2}) user should( not)? be deleted$/) do |id, neg|
  expect(get_resource(User, id)).to neg ? be_truthy : be_falsey
end

Then(/^no user should be deleted$/) do
  expect(User.count).to eql @user_count
end