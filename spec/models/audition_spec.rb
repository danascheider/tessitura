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
  end
end