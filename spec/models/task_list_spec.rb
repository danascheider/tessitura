require 'spec_helper'

describe TaskList do 
  include Sinatra::ErrorHandling
  include Sinatra::GeneralHelperMethods

  let(:owner) { FactoryGirl.create(:user_with_task_lists) }
  let(:task_list) { owner.default_task_list }

  describe 'attributes' do 
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:owner) }
    it { is_expected.to respond_to(:owner_id) }
  end

  describe 'associations' do 
    it 'is destroyed with its user' do 
      owner = FactoryGirl.create(:user_with_task_lists)
      task_list = owner.default_task_list
      owner.destroy
      expect(TaskList[task_list.id]).to be nil
    end
  end

  describe 'class methods' do 
    describe '::create' do 
      context 'with valid attributes' do 
        let(:user) { FactoryGirl.create(:user) }
        let(:attributes) { { user_id: user.id } }

        it 'creates the task list' do 
          expect{ TaskList.create(attributes) }.to change(TaskList, :count).by(1)
        end
      end

      context 'with invalid attributes' do 
        let(:attributes) { { user_id: 'foo' } }

        it 'doesn\'t create the task list' do 
          expect{ TaskList.try_rescue(:create, attributes) }.not_to change(TaskList, :count)
        end

        it 'raises Sequel::ValidationFailed' do 
          expect{ TaskList.create(attributes) }.to raise_error(Sequel::ValidationFailed)
        end
      end
    end
  end

  describe 'instance methods' do 
    describe '#destroy' do 
      before(:each) do 
        @list = task_list
      end

      it 'destroys the task list' do 
        expect{ @list.destroy }.to change(TaskList, :count).by(-1)
      end

      it 'destroys the tasks on the list' do 
        count = @list.tasks.count
        expect{ @list.destroy }.to change(Task, :count).by(-1 * count)
      end
    end

    describe '#to_hashes' do 
      it 'returns an array of its tasks as hashes' do 
        list = task_list.tasks.map(&:to_h)
        expect(task_list.to_hashes).to eql list
      end
    end

    describe '#to_json' do 
      it 'converts to an array first' do 
        expect(task_list.to_json).to eql task_list.to_a.to_json
      end
    end

    describe '#owner' do 
      it 'returns the task list\'s associated user' do
        expect(task_list.owner).to eql owner
      end
    end

    describe '#owner_id' do 
      it 'returns its user\'s ID' do 
        expect(task_list.owner_id).to eql owner.id
      end
    end

    describe '#to_a' do 
      it 'returns its tasks' do 
        expect(task_list.to_a).to eql task_list.tasks.map(&:to_h)
      end

      it 'returns an array object' do 
        expect(task_list.to_a).to be_an(Array)
      end
    end

    describe '#update' do 
      before(:each) do 
        @list = (@user = owner).task_lists.first
      end

      context 'with valid attributes' do 
        let(:attributes) { { title: 'Personal Tasks' } }

        it 'updates the list' do 
          @list.update(attributes)
          expect(@list.title).to eql 'Personal Tasks'
        end
      end

      context 'with invalid attributes' do 
        let(:attributes) { { user_id: nil } }

        it 'doesn\'t update the list' do 
          expect{ update_resource(attributes, @list) }.not_to change(TaskList[@list.id], :user_id)
        end

        it 'raises Sequel::ValidationFailed' do 
          expect{ @list.update(attributes) }.to raise_error(Sequel::ValidationFailed)
        end
      end
    end
  end

  describe 'validations' do 
    let(:new_list) { FactoryGirl.build(:task_list, user_id: nil) }

    context 'without a user' do 
      it 'is invalid' do 
        expect(new_list).not_to be_valid
      end
    end

    context 'with a user' do 
      it 'is valid' do 
        new_list.user_id = owner.id 
        expect(new_list).to be_valid
      end
    end
  end
end