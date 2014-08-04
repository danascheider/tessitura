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

  describe '::dump_tasks' do 
    before(:each) do 
      FactoryGirl.create_list(:task, 3)
      @output = "TASKS:\n"
      Task.all.each {|task| @output << "#{task.to_hash}\n" }
    end

    it 'lists all the task data' do 
      expect { dump_tasks }.to output(@output).to_stdout
    end
  end

  describe '::dump_user_tasks' do 
    before(:each) do 
      @user = FactoryGirl.create(:user_with_task_lists)
      @output = "USER #{@user.id}'S TASKS:\n"
      @user.tasks.each {|task| @output << "#{task.to_hash}\n"}
    end

    it 'lists data about the user\'s tasks' do 
      expect { dump_user_tasks(@user.id) }.to output(@output).to_stdout
    end
  end

  describe '::get_changed_task' do 
    before(:each) do 
      @task = FactoryGirl.create(:task, priority: 'not_important')
      @id = @task.id
      Task.find(@id).update!(priority: 'urgent')
    end

    context '@task' do 
      it 'does\'t update its attributes' do 
        expect(@task.priority).to eql 'not_important'
      end
    end

    context 'changed task' do 
      it 'gets the new attributes' do 
        expect(get_changed_task.priority).to eql 'urgent'
      end
    end
  end

  describe '::get_changed_user' do 
    before(:each) do 
      @user = FactoryGirl.create(:user, city: 'Buenos Aires')
      @id = @user.id
      User.find(@id).update!(city: 'Stockholm')
    end

    context '@user' do 
      it 'doesn\'t update its attributes' do 
        expect(@user.city).to eql 'Buenos Aires'
      end
    end

    context 'changed user' do 
      it 'gets the user\'s current attributes' do 
        expect(get_changed_user.city).to eql 'Stockholm'
      end
    end
  end

  describe '::get_resource' do 
    before(:each) do 
      FactoryGirl.create_list(:user_with_task_lists, 4)
    end

    context 'with no block given' do 
      context 'users' do 
        context 'when the user exists' do 
          it 'returns the user object' do 
            id = User.first.id
            expect(get_resource(User, id)).to eql User.first
          end
        end

        context 'when the user doesn\'t exist' do 
          it 'returns nil' do 
            expect(get_resource(User, 1000000)).to eql nil
          end
        end
      end

      context 'tasks' do 
        context 'when the task exists' do 
          it 'returns the task' do 
            id = Task.first.id
            expect(get_resource(Task, id)).to eql Task.first
          end
        end

        context 'when the task doesn\'t exist' do 
          it 'returns nil' do 
            expect(get_resource(Task, 1000000)).to eql nil
          end
        end
      end
    end

    context 'block given' do 
      context 'users' do 
        context 'when the user exists' do 
          it 'executes the block' do 
            id = User.first.id
            expect(get_resource(User, id) {|user| user.username.upcase }).to eql User.first.username.upcase
          end
        end

        context 'when the user doesn\'t exist' do 
          it 'returns nil' do 
            expect(get_resource(User, 1000000) {|user| user.username.upcase }).to eql nil
          end
        end
      end

      context 'tasks' do 
        context 'when the task exists' do 
          it 'returns the output of the block' do
            id = Task.first.id
            expect(get_resource(Task, id) {|task| task.title.upcase }).to eql Task.first.title.upcase
          end
        end
      end

      context 'when the task doesn\'t exist' do 
        it 'returns nil' do 
          expect(get_resource(Task, 1000000) {|task| task.title.upcase }).to eql nil
        end
      end
    end
  end

  describe '::find_task' do 
    before(:each) do 
      @task = FactoryGirl.create(:task)
    end

    it 'returns the task' do 
      expect(find_task(@task.id)).to eql Task.find(@task.id)
    end
  end

  describe '::find_user' do 
    before(:each) do 
      @user = FactoryGirl.create(:user)
    end

    it 'returns the user' do 
      expect(find_user(@user.id)).to eql User.find(@user.id)
    end
  end
end