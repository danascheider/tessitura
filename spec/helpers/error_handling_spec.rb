require 'spec_helper'

describe Canto::ErrorHandling do 
  include Canto::ErrorHandling

  describe '::begin_and_rescue' do 
    context 'when no error is raised' do 
      it 'yields output from the block' do 
        expect(begin_and_rescue(StandardError, 500) { 'Hello World' }).to eql 'Hello World'
      end
    end

    context 'when an error is raised' do 
      it 'returns a status code' do 
        expect(begin_and_rescue(ActiveRecord::RecordNotFound, 404) { User.find(100) }).to eql 404
      end
    end
  end

  describe '::get_resource' do 
    context 'when the resource exists' do 
      it 'returns the resource' do 
        user = FactoryGirl.create(:user)
        expect(get_resource(User, user.id)).to eql user
      end
    end

    context 'when the resource doesn\'t exist' do 
      it 'returns nil' do 
        expect(get_resource(User, 1000)).to eql nil
      end
    end
  end

  describe '::parse_json' do 
    context 'when a valid JSON object is given' do 
      it 'returns a hash' do 
        expect(parse_json({"foo"=>"bar"}.to_json)).to eql({ 'foo' => 'bar' })
      end
    end

    context 'when no valid JSON object is given' do 
      it 'returns nil' do 
        expect(parse_json("")).to eql nil
      end
    end
  end
end