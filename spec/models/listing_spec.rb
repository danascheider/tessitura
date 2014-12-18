require 'spec_helper'

describe Listing do 
  include Sinatra::ErrorHandling

  describe 'attributes' do 
    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :web_site }
    it { is_expected.to respond_to :type }
    it { is_expected.to respond_to :country }
    it { is_expected.to respond_to :region }
    it { is_expected.to respond_to :city }
    it { is_expected.to respond_to :program_start_date }
    it { is_expected.to respond_to :program_end_date }
    it { is_expected.to respond_to :organization }
    it { is_expected.to respond_to :deadline }
  end

  describe 'validations' do 
    let(:listing) { FactoryGirl.build(:listing) }

    it 'is invalid without a title' do 
      listing.title = nil
      expect(listing).not_to be_valid
    end

    it 'is invalid without a web site' do 
      listing.web_site = nil 
      expect(listing).not_to be_valid
    end

    it 'is invalid without a country' do 
      listing.country = nil 
      expect(listing).not_to be_valid
    end

    it 'is invalid without a city' do 
      listing.city = nil 
      expect(listing).not_to be_valid
    end

    it 'is invalid without a start date' do 
      listing.program_start_date = nil 
      expect(listing).not_to be_valid
    end
  end
end