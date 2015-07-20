require 'spec_helper'

describe Fach do 
  include Sinatra::ErrorHandling

  describe 'attributes' do 
    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:quality) }
    it { is_expected.to respond_to(:coloratura) }
  end

  describe 'validations' do 
    ['soprano', 'mezzo-soprano', 'contralto', 'countertenor', 'tenor', 'baritone', 'bass'].each do |type|
      it "can have type #{type}" do 
        fach = Fach.new(type: type)
        expect(fach).to be_valid
      end
    end

    it 'can\'t have another type' do 
      fach = Fach.new({type: 'Dalmatian'})
      expect(fach).not_to be_valid
    end

    it 'is invalid without a type' do 
      fach = Fach.new({type: nil})
      expect(fach).not_to be_valid
    end

    ['lyric', 'dramatic'].each do |quality|
      it "can have quality #{quality}" do 
        fach = Fach.new(type: 'soprano', quality: quality)
        expect(fach).to be_valid
      end
    end

    it 'can\'t have another quality' do 
      fach = Fach.new(type: 'soprano', quality: 'superior')
      expect(fach).not_to be_valid
    end

    it 'is valid without a quality' do 
      fach = Fach.new(type: 'soprano')
      expect(fach).to be_valid
    end
  end

  describe '::infer' do 
    let(:fach1) { FactoryGirl.create(:fach, type: 'baritone', quality: 'lyric', coloratura: false) }
    let(:fach2) { FactoryGirl.create(:fach, type: 'baritone', quality: 'lyric', coloratura: true) }

    it 'returns the correct fach' do 
      right, wrong = fach1, fach2
      expect(Fach.infer({type: 'baritone', quality: 'lyric'})).to eql right
    end
  end

  describe 'instance methods' do 
    let(:fach) { FactoryGirl.create(:fach) }

    describe 'to_hash' do 
      it 'returns its attributes' do 
        expect(fach.to_hash).to eq({id: fach.id, type: 'soprano', quality: 'lyric', coloratura: true})
      end

      it 'doesn\'t include blank attributes' do 
        fach.coloratura = nil
        expect(fach.to_hash).to eq({id: fach.id, type: 'soprano', quality: 'lyric'})
      end
    end

    describe 'to_h' do 
      it 'is an alias for to_hash' do 
        expect(fach.to_h).to eq(fach.to_hash)
      end
    end

    describe 'to_json' do 
      it 'returns its hash as JSON' do 
        expect(fach.to_json).to eq(fach.to_h.to_json)
      end
    end
  end
end