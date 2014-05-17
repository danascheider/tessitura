Given /^I am a user$/ do
  @user = FactoryGirl.create(:user)
end

When /^I navigate to my new to-do item page$/ do
  visit new_user_todo_item_path(@user.id)
end