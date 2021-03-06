require 'spec_helper'

# Helper methods live in ../features/support/helpers.rb

describe 'test helper methods' do 
  describe '::dump_users' do
    before(:each) do 
      FactoryGirl.create_list(:user, 3)
      @output = "USERS:\n"
      User.all.each do |user|
        hash = user.to_h.reject {|k,v| k.in? [:created_at, :updated_at] }
        hash[:username], hash[:password] = user.username, user.password
        @output << "#{hash.reject {|k,v| k.in? [:created_at, :updated_at]}}\n"
      end
    end

    it 'lists all the user data' do 
      expect { dump_users }.to output(@output).to_stdout
    end
  end 

  describe '::dump_tasks' do 
    before(:each) do 
      FactoryGirl.create_list(:task, 3)
      @output = "TASKS:\n"
      Task.all.each {|task| @output << "#{task.to_h.reject {|k,v| k.in? [:created_at, :updated_at]}}\n" }
    end

    it 'lists all the task data' do 
      expect { dump_tasks }.to output(@output).to_stdout
    end
  end

  describe '::dump_user_tasks' do 
    before(:each) do 
      @user = FactoryGirl.create(:user_with_task_lists)
      @output = "USER #{@user.id}'S TASKS:\n"
      @user.tasks.flatten.each {|task| @output << "#{task.to_h.reject {|k,v| k.in? [:created_at, :updated_at]}}\n" }
    end

    it 'lists data about the user\'s tasks' do 
      expect { dump_user_tasks(@user.id) }.to output(@output).to_stdout
    end
  end
end