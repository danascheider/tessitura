require 'spec_helper'

describe Sinatra::ErrorHandling do 
  include Sinatra::ErrorHandling

  describe '::get_resource' do 
    context 'when the resource exists' do 
      let(:user) { FactoryGirl.create(:user) }
      
      context 'no block given' do 
        it 'returns the resource' do 
          expect(get_resource(User, user.id)).to eql user
        end
      end

      context 'block given' do 
        it 'returns the output of the block' do 
          expect(get_resource(User, user.id) {|user| user.username.upcase! }).to eql user.username.upcase!
        end
      end
    end

    context 'when the resource doesn\'t exist' do 
      context 'no block given' do 
        it 'returns nil' do 
          expect(get_resource(User, 20000)).to eql nil
        end
      end

      context 'block given' do 
        it 'returns nil' do 
          expect(get_resource(User, 20000) {|user| user.username.upcase! }).to eql nil
        end
      end
    end
  end

  describe '::parse_json' do 
    context 'when a valid JSON object is given' do 
      it 'returns a hash' do 
        expect(parse_json({"foo"=>"bar"}.to_json)).to eql({ :foo => 'bar' })
      end
    end

    context 'when no valid JSON object is given' do 
      it 'returns nil' do 
        expect(parse_json("")).to eql nil
      end
    end
  end
  
  describe '::create_resource' do 
    let(:users) { FactoryGirl.create_list(:user_with_task_lists, 2) }
    let(:list) { users.last.default_task_list }

    context 'with valid attributes' do 
      context 'users' do 
        it 'creates a new user' do 
          expect(User).to receive(:create)
          create_resource(User, username: 'frankjones', password: 'frankjonespwd', email: 'fj@a.com')
        end

        it 'returns status 201' do 
          allow(User).to receive(:create).and_return(true)
          expect(create_resource(User, { username: 'frankjones', password: 'frankjonespwd', email: 'fj@a.com' })).to eql 201
        end
      end

      context 'tasks' do 
        it 'creates a new task' do 
          expect(Task).to receive(:create)
          create_resource(Task, title: 'Water the lawn', task_list_id: list.id)
        end

        it 'returns status 201' do 
          allow(Task).to receive(:create).and_return(true)
          expect(create_resource(Task, title: 'Water the lawn', task_list_id: list.id)).to eql 201
        end
      end
    end

    context 'with invalid attributes' do 
      context 'user' do 
        it 'returns 422' do 
          expect(create_resource(User, username: 'abcdefg')).to eql 422
        end
      end

      context 'task' do 
        it 'returns 422' do 
          expect(create_resource(Task, title: nil)).to eql 422
        end
      end
    end

    context 'with no attribute hash' do 
      it 'returns 422' do 
        expect(create_resource(User, nil)).to eql 422
      end
    end

    context 'with unknown attributes' do 
      context 'users' do 
        it 'returns 422' do 
          expect(create_resource(User, username: 'u3jfuo', password: 'apssowdr', email: 'b@c.com', foo: 'bar')).to eql 422
        end
      end

      context 'tasks' do 
        it 'returns 422' do 
          expect(create_resource(Task, title: 'My Task', foo: 12)).to eql 422
        end
      end
    end
  end

  describe '::destroy_resource' do 
    let(:user) { FactoryGirl.create(:user_with_task_lists) }
    let(:task) { user.task_lists.first.tasks.first }

    context 'when the resource exists' do 
      context 'users' do 
        it 'deletes the user' do 
          expect_any_instance_of(User).to receive(:destroy)
          destroy_resource(user)
        end

        it 'returns 204' do 
          expect(destroy_resource(user)).to eql 204
        end
      end

      context 'tasks' do 
        it 'deletes the task' do 
          expect_any_instance_of(Task).to receive(:destroy)
          destroy_resource(task)
        end

        it 'returns 204' do 
          expect(destroy_resource(task)).to eql 204
        end
      end
    end

    context 'when the resource doesn\'t exist' do 
      it 'returns 404' do 
        expect(destroy_resource(nil)).to eql 404
      end
    end

    context 'when the resource can\'t be destroyed' do 
      it 'returns status 403' do
        user.update(admin: true) # Last admin can't be deleted
        expect(destroy_resource(user)).to eql 403
      end
    end
  end

  describe '::update_resource' do 
    let(:user) { FactoryGirl.create(:user_with_task_lists) }
    let(:task) { user.task_lists.first.tasks.first }

    context 'with valid attributes' do 
      context 'users' do 
        it 'updates the user' do 
          expect_any_instance_of(User).to receive(:update)
          update_resource({ city: 'Honolulu' }, user)
        end
      end

      context 'tasks' do 
        it 'updates the task' do 
          expect_any_instance_of(Task).to receive(:update)
          update_resource({ priority: 'high' }, task)
        end
      end
    end

    context 'with invalid attributes' do 
      context 'users' do 
        it 'returns 422' do 
          expect(update_resource({ username: nil }, user)).to eql 422
        end
      end

      context 'tasks' do 
        it 'returns 422' do 
          expect(update_resource({ task_list_id: nil }, task)).to eql 422
        end
      end
    end

    context 'with unknown attributes' do 
      context 'users' do 
        it 'returns 422' do 
          expect(update_resource({ foo: 'bar' }, user)).to eql 422
        end
      end

      context 'tasks' do 
        it 'returns 422' do 
          expect(update_resource({ foo: 'bar' }, task)).to eql 422
        end
      end
    end

    context 'with a missing resource' do 
      it 'returns 404' do 
        expect(update_resource({ country: 'Peru' }, nil)).to eql 404
      end
    end
  end
end