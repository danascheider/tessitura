require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  before(:all) do 
    Task.create!(title: 'Walk the dog')
    Task.create!(title: 'Take out the trash')
    Task.create!(title: 'Call mom', complete: true)
  end

  context 'GET' do 
    describe 'task list route' do 
      it 'returns all the tasks as a JSON object' do 
        get '/tasks'
        expect(last_response.body).to eql Task.all.to_json
      end
    end

    describe 'individual task route' do 
      it 'returns a single task as a JSON object' do 
        get '/tasks/1'
        expect(last_response.body).to eql Task.find(1).to_json
      end
    end

    describe 'scoped task route' do 
      it 'returns only the incomplete tasks' do 
        get 'tasks?complete=false'
        expect(last_response.body).not_to include(Task.find(3).to_json)
      end
    end
  end

  context 'POST' do 
    describe 'new task route'
  end
end