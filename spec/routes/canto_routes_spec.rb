require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  before(:all) do 
    Task.create!(title: 'Walk the dog')
    Task.create!(title: 'Take out the trash')
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

    describe 'scoped task route'
  end

  context 'POST' do 
    describe 'new task route'
  end
end