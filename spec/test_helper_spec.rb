require 'spec_helper'

# Helper methods live in ../features/support/helpers.rb

describe 'test helper methods' do 
  describe '::dump_users' do
    before(:each) do 
      FactoryGirl.create_list(:user, 3)
      @output = "USERS:\n"
      User.all.each do |user|
        hash = user.to_hash
        hash[:username], hash[:password] = user.username, user.password
        @output << "#{hash}\n"
      end
    end
    
    it 'lists all the user data' do 
      expect { dump_users }.to output(@output).to_stdout
    end
  end 
end