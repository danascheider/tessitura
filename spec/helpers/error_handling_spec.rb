require 'spec_helper'

describe Sinatra::ErrorHandling do 
  include Sinatra::ErrorHandling
  include Sinatra::GeneralHelperMethods

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

  describe '::update_resource' do 
    let(:user) { FactoryGirl.create(:user_with_task_lists) }
    let(:task) { user.task_lists.first.tasks.first }

    context 'with valid attributes' do 
      context 'users' do 
        let(:hash) { {id: user.id, city: 'Honolulu'} }

        it 'doesn\'t raise a primary key error' do 
          expect{ update_resource(hash, user) }.not_to raise_error
        end

        it 'updates the user' do 
          expect_any_instance_of(User).to receive(:try_rescue).with(:update, hash.only(:city))
          update_resource(hash, user)
        end

        it 'returns an array with status and updated object' do 
          updated = (user.update(hash.only(:city))).to_json
          expect(update_resource(hash, user)).to eql([200, updated])
        end
      end

      context 'tasks' do 
        let(:hash) { {id: task.id, priority: 'High'} }
        it 'doesn\'t raise a primary key error' do 
          expect{ update_resource(hash, task) }.not_to raise_error
        end

        it 'updates the task' do 
          expect_any_instance_of(Task).to receive(:try_rescue).with(:update, hash.only(:priority))
          update_resource(hash, task)
        end

        it 'returns an array with status and updated object' do 
          updated = (task.update(hash.only(:priority))).to_json
          expect(update_resource(hash, task)).to eql([200, updated])
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

    context 'with unchanged attributes' do 
      let(:task) { FactoryGirl.create(:task, status: 'Blocking') }
      let(:attributes) { { id: task.id, status: 'Blocking' }}

      it 'returns an array with status and unchanged object' do 
        expect(update_resource(attributes, task)).to eql([200, task.to_json])
      end
    end
  end

  describe '::verify_uniform_ownership' do 
    let(:users) { FactoryGirl.create_list(:user_with_task_lists, 2) }

    context 'users' do 
      it 'returns a falsey value' do 
        expect(verify_uniform_ownership(users)).to be_falsey
      end
    end

    context 'task lists' do 
      context 'lists belong to the same user' do 
        it 'returns a truthy value' do 
          expect(verify_uniform_ownership(users.first.task_lists)).to be_truthy
        end

        it 'returns the owner ID' do 
          expect(verify_uniform_ownership(users.first.task_lists)).to eql users.first.id
        end
      end

      context 'lists do not belong to the same user' do 
        it 'returns a falsey value' do 
          lists = [users.first.task_lists.first, users.last.task_lists].flatten
          expect(verify_uniform_ownership(lists)).to be_falsey
        end
      end
    end

    context 'tasks' do 
      context 'tasks are on the same list' do 
        it 'returns a truthy value' do 
          tasks = users.first.task_lists.first.tasks[0..1]
          expect(verify_uniform_ownership(tasks)).to be_truthy
        end
      end

      context 'different lists, same owner' do 
        let(:lists) { users.first.task_lists }
        let(:tasks) { [lists.first.tasks, lists.last.tasks].flatten }

        it 'returns a truthy value' do 
          expect(verify_uniform_ownership(tasks)).to be_truthy
        end

        it 'returns the owner ID' do 
          expect(verify_uniform_ownership(tasks)).to eql users.first.id
        end
      end

      context 'different owners' do 
        it 'returns a falsey value' do 
          tasks = [users.first.tasks, users.last.tasks].flatten
          expect(verify_uniform_ownership(tasks)).to be_falsey 
        end
      end
    end
  end
end