require 'spec_helper'

describe Audition do 
  it { is_expected.to respond_to :country }
  it { is_expected.to respond_to :region }
  it { is_expected.to respond_to :city }
  it { is_expected.to respond_to :date }
  it { is_expected.to respond_to :deadline }
  it { is_expected.to respond_to :fee }
  it { is_expected.to respond_to :pianist_provided }
  it { is_expected.to respond_to :can_bring_own_pianist }
  it { is_expected.to respond_to :pianist_fee }
  it { is_expected.to respond_to :created_at }
  it { is_expected.to respond_to :updated_at }

  describe 'associations' do 
    it 'is deleted with its associated season' do 
      season = FactoryGirl.create(:season_with_auditions)
      auditions = season.auditions
      season.destroy
      auditions.each {|a| expect(Audition[a.id]).to be nil }
    end
  end

  describe 'validations' do 
    before(:each) do 
      @audition = FactoryGirl.build(:audition)
    end

    it 'is invalid without a country' do 
      @audition.country = nil
      expect(@audition).not_to be_valid
    end

    it 'is invalid without a city' do 
      @audition.city = nil
    end

    it 'is invalid without a date' do 
      @audition.date = nil 
      expect(@audition).not_to be_valid
    end

    it 'is invalid without a region if in the US' do 
      @audition.country = 'USA'
      @audition.region = nil
      expect(@audition).not_to be_valid
    end

    it 'is valid without a region if not in the US' do 
      @audition.country = 'Bolivia'
      @audition.region = nil
      expect(@audition).to be_valid
    end
  end

  describe 'instance methods' do 
    let(:audition) { FactoryGirl.create(:audition) }

    describe '#to_h' do 
      let(:hash) {
        {
          id: audition.id,
          season_id: audition.season_id,
          country: audition.country,
          region: audition.region,
          city: audition.city,
          date: audition.date,
          deadline: audition.deadline,
          created_at: audition.created_at,
        }
      }

      it 'returns only non-blank attributes' do 
        expect(audition.to_h).to eql(hash)
      end

      it 'includes attributes that are present' do 
        audition.pianist_fee = 30.00
        expect(audition.to_h).to have_key(:pianist_fee)
      end

      it 'is aliased as #to_hash' do 
        expect(audition.to_hash).to eql(audition.to_h)
      end
    end

    describe '#to_json' do 
      it 'converts to a hash first' do 
        expect(audition.to_json).to eql(audition.to_h.to_json)
      end
    end
  end
end