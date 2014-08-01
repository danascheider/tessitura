Given(/^there are (\d+|no) users$/) do |number|
  # @user_count is invoked in 'no user should be created', below
  number == 'no' ? User.count == 0 : number.times { FactoryGirl.create(:user) }
  @user_count = User.count
end

Given(/^there are users with the following attributes:$/) do |attributes|
  attributes.hashes.each do |hash|
    FactoryGirl.create(:user, hash)
  end
end

Given(/^each user has (\d+) tasks$/) do |number|
  User.all.each do |user|
    @list = TaskList.create!(user_id: user.id)
    number.times { FactoryGirl.create(:task, task_list_id: @list.id) }
  end
end

# ADMIN STEPS
# ===========

Then(/^the user should be an admin$/) do
  @user.should be_admin
end

Then(/^the (\d+)(?:[a-z]{2}) user should (not )?be an admin$/) do |id, neg|
  User.find(id).should be_admin unless neg
end

# USER CREATION STEPS
# ===================

Then(/^(a|no) new user should be created with the following attributes:$/) do |art, attributes|
  attributes.hashes.each do |hash|
    if art == 'a'
      User.last.to_hash.each do |key, value|
        value = value == true ? 'true' : value
        expect(hash[key.to_s]).to eql value if hash.has_key? key.to_s
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