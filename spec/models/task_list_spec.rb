require 'spec_helper'

describe TaskList do 
  before(:each) do 
    @task_list = FactoryGirl.create(:task_list_with_tasks)
  end

  describe 'attributes' do 
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:owner) }
  end

  describe 'instance methods' do 
    describe 'to_hashes' do 
      it 'returns an array of its tasks as hashes' do 
        list = @task_list.tasks.map {|task| task.to_hash }
        expect(@task_list.to_a).to eql list
      end
    end
  end

  describe 'associations' do 
    context 'when its user is destroyed' do 
      it 'is destroyed' do 
        list = FactoryGirl.create(:task_list)
        list.user.destroy 
        expect { TaskList.find(list.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'creation' do 
    describe 'validations' do 
      before(:each) do 
        @new_list = FactoryGirl.build(:task_list, user_id: nil)
      end

      context 'without a user' do 
        it 'is invalid' do 
          expect(@new_list).not_to be_valid
        end
      end

      context 'with a user' do 
        it 'is valid' do 
          @new_list.user_id = @task_list.user.id 
          expect(@new_list).to be_valid
        end
      end
    end
  end
end