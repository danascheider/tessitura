# Admin Users
# ===========
Then(/^the (\d+)(?:[a-z]{2}) user should (not|yes)?(?: )?be an admin$/) do |id, neg|
  expect(User[id].admin?).to (neg == 'not') ? be_falsey : be_truthy
end

# Create User
# ===========
Then(/^(a|no) new user should be created with the following attributes:$/) do |art, attributes|
  if art == 'a'
    (attributes.hashes.first).each do |key, value|
      expect(User.last.send(key).to_s).to eql value
    end
  else
    expect(User.count).to eql @user_count
  end
end

Then(/^no user should be created$/) do 
  expect(User.count).to eql @user_count
end

# Update User
# ===========
Then(/^the (\d+)(?:[a-z]{2}) user's (.*) should be changed to (.*)$/) do |id, attr, value|
  @user = User[id]
  expect(@user.to_hash[attr.intern]).to eql value
end

Then(/^the user's (.*) should not be changed$/) do |attr|
  expect(User[@user.id].to_hash[attr.intern]).to eql @user.to_hash[attr.intern]
end

# Delete User
# ===========
Then(/^the (\d+)(?:[a-z]{2}) user should (not |yes )?be deleted$/) do |id, neg|
  expect(User[id]).to (neg == 'not ') ? be_truthy : be_falsey 
end

Then(/^no user should be deleted$/) do
  expect(User.count).to eql @user_count
end

# Background
# ==========
Given(/^there is a user with the following attributes:$/) do |string|
  string.hashes.each {|hash| FactoryGirl.create(:user, hash) }
end