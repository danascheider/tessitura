require 'spec_helper'

describe Listing do 

  describe 'attributes' do 
    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :season_id }
    it { is_expected.to respond_to :created_at }
    it { is_expected.to respond_to :updated_at }
  end

  describe 'instance methods' do 
  end

  describe 'validations' do 
    let(:listing) { FactoryGirl.create(:listing) }

    it 'is invalid without a title' do 
      listing.title = nil
      expect(listing).not_to be_valid
    end
  end
end