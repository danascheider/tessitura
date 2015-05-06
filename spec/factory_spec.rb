require 'spec_helper'

describe 'factories', infrastructure: true do 
  describe 'FactoryGirl' do 
    FactoryGirl.factories.map(&:name).each do |factory_name|
      describe "#{factory_name} factory" do 
        it 'is valid' do 
          factory = FactoryGirl.build(factory_name)
          if factory.respond_to?(:valid?)
            expect(factory).to be_valid, lambda { factory.errors.full_messages.join("\n") }
          end
        end
      end
    end
  end

  describe 'user factory' do 
    describe 'plain vanilla user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'has a valid e-mail' do 
        expect(user.email).to match(/\w+@\w+\.\w{2,3}/)
      end

      it 'has a valid username' do 
        expect(user.username).to match(/(\w|-){6,}/)
      end

      it 'has a valid password' do 
        expect(user.password).to match(/(.*){8,}/)
      end

      it 'has first_name \'Test\'' do 
        expect(user.first_name).to eql 'Test'
      end

      it 'has last_name \'User\'' do 
        expect(user.last_name).to eql 'User'
      end

      it 'is not an admin' do 
        expect(user.admin).to be false
      end

      it 'is a User' do 
        expect(user).to be_a User
      end

      it 'has a, ID, username, password, email, country, first_name, last_name, and created_at by default' do 
        [:id, :username, :password, :email, :first_name, :last_name, :country, :admin, :created_at].each do |attribute|
          expect(user.send(attribute)).not_to be_nil
        end
      end

      it 'has no other defined attributes on creation' do 
        nil_columns = user.columns - [:id, :username, :password, :email, :country, :admin, :first_name, :last_name, :created_at]
        nil_columns.each {|col| expect(user.send(col)).to be_nil }
      end

      it 'defines a unique username' do 
        expect(FactoryGirl.create(:user).username).not_to eql user.username
      end

      it 'defines a  unique password' do 
        # Users don't need to have unique passwords, but the user factory should, to
        # ensure the integrity of security tests
        expect(FactoryGirl.create(:user).password).not_to eql user.password
      end

      it 'defines a unique email' do 
        expect(FactoryGirl.create(:user).email).not_to eql(user.email)
      end
    end

    describe 'user with task lists' do 
      let(:user) { FactoryGirl.create(:user_with_task_lists) }

      it 'is a User' do 
        expect(user).to be_a User
      end

      it 'has two task lists' do 
        expect(user.task_lists.count).to eql 2
      end

      it 'has some incomplete tasks' do 
        expect(Task.incomplete.where(owner_id: user.id)).not_to be_empty
      end

      it 'has some complete tasks' do 
        expect(Task.complete.where(owner_id: user.id)).not_to be_empty
      end
    end
  end
end