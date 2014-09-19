require 'spec_helper'

describe TaskList do 
  let(:owner) { FactoryGirl.create(:user_with_task_lists) }
  let(:task_list) { owner.default_task_list }

  describe 'attributes' do 
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:owner) }
    it { is_expected.to respond_to(:owner_id) }
  end

  describe 'instance methods' do 
    describe '#to_hashes' do 
      it 'returns an array of its tasks as hashes' do 
        list = task_list.tasks.map {|task| task.to_hash }
        expect(task_list.to_hashes).to eql list
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
        expect(task_list.to_a).to eql task_list.tasks.map {|task| task.to_hash }
      end

      it 'returns an array object' do 
        expect(task_list.to_a).to be_an(Array)
      end
    end
  end

  describe 'associations' do 
    context 'when its user is destroyed' do 
      it 'is destroyed' do 
        list = FactoryGirl.create(:task_list)
        list.user.destroy 
        expect(TaskList[list.id]).to eql nil
      end
    end
  end

  describe 'creation' do 
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
end