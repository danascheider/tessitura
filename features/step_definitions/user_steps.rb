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
  User.find(id).should be_admin unless neg == 'not'
end

# USER CREATION STEPS
# ===================

Then(/^(a|no) new user should be created with the following attributes:$/) do |art, attributes|
  dump_users
  attributes.hashes.each do |hash|
    if art == 'a'
      User.last.to_hash.each do |key, value|
        value = value == true ? 'true' : value
        expect(value).to eql hash[key.to_s] if hash.has_key? key.to_s
      end
    else 
      expect(User.find_by(username: hash[:username])).to eql nil
    end
  end
end

Then(/^a user named '(\w+) (\w+)' should be created$/) do |first, last|
  # @user is called in 'the user should be an admin'
  (@user = User.find_by(first_name: first, last_name: last)).should_not eql nil
end

Then(/^no user should be created$/) do 
  User.count.should == @user_count
end

# USER UPDATE STEPS
# =================
Then(/^the (\d+)(?:[a-z]{2}) user's (.*) should be changed to '(.*)'$/) do |id, attr, value|
  @user = User.find(id)
  expect(@user.to_hash[attr.intern]).to eql value
end

Then(/^the user's (.*) should not be changed$/) do |attr|
  expect(get_changed_user.to_hash[attr.intern]).to eql @user.to_hash[attr.intern]
end

# USER DELETION STEPS
# ===================
Then(/^the (\d+)(?:[a-z]{2}) user should( not)? be deleted$/) do |id, neg|
  if neg == nil
    expect {User.find(id)}.to raise_error ActiveRecord::RecordNotFound
  else
    expect(User.find(id)).to be_a(User)
  end
end

Then(/^no user should be deleted$/) do
  expect(User.count).to eql @user_count
end