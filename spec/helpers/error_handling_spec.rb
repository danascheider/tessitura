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

  describe '::set_attributes' do 
    let(:task) { FactoryGirl.create(:task) }
    let(:valid_attributes) { { id: task.id, position: 4 } }
    let(:invalid_attributes) { { id: task.id, title: nil } }

    context 'when the resource exists' do 
      context 'valid attributes' do 
        it 'sets the task attributes' do 
          expect(task).to receive(:set).with({ position: 4 })
          set_attributes(valid_attributes, task)
        end

        it 'doesn\'t persist the changes' do 
          set_attributes(valid_attributes, task)
          expect(task).to be_modified
        end

        it 'doesn\'t raise a Sequel error' do 
          expect{set_attributes(valid_attributes, task)}.not_to raise_error
        end
      end

      context 'invalid attributes' do 
        it 'sets the task attributes' do 
          expect(task).to receive(:set).with({title: nil})
          set_attributes(invalid_attributes, task)
        end

        it 'doesn\'t persist the changes' do 
          set_attributes(invalid_attributes, task)
          expect(task).to be_modified
        end

        it 'doesn\'t raise a validation error' do 
          expect{ set_attributes(invalid_attributes, task) }.not_to raise_error
        end
      end
    end

    context 'when the resource doesn\'t exist' do 
      it 'returns nil' do 
        expect(set_attributes(valid_attributes, Task[20000000])).to eql nil
      end
    end
  end

  describe '::update_resource' do 
    let(:user) { FactoryGirl.create(:user_with_task_lists) }
    let(:task) { user.task_lists.first.tasks.first }

    context 'with valid attributes' do 
      context 'users' do 
        it 'doesn\'t raise a primary key error' do 
          hash = { id: user.id, city: 'Honolulu' }
          expect{ update_resource(hash, user) }.not_to raise_error
        end

        it 'updates the user' do 
          expect_any_instance_of(User).to receive(:update)
          update_resource({ id: user.id, city: 'Honolulu' }, user)
        end

        it 'returns an array with status and updated object' do 
          updated = (user.update({city: 'Honolulu'})).to_json
          expect(update_resource({id: user.id, city: 'Honolulu'}, user)).to eql([200, updated])
        end
      end

      context 'tasks' do 
        it 'doesn\'t raise a primary key error' do 
          hash = { id: task.id, priority: 'High' }
          expect{ update_resource(hash, task) }.not_to raise_error
        end

        it 'updates the task' do 
          expect_any_instance_of(Task).to receive(:update)
          update_resource({ id: task.id, priority: 'High' }, task)
        end

        it 'returns an array with status and updated object' do 
          updated = (task.update({priority: 'High'})).to_json
          expect(update_resource({id: task.id, priority: 'High'}, task)).to eql([200, updated])
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
end