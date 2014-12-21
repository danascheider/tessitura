require 'spec_helper'

describe Listing do 

  describe 'attributes' do 
    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :program_start_date }
    it { is_expected.to respond_to :program_end_date }
    it { is_expected.to respond_to :deadline }
    it { is_expected.to respond_to :application_url }
    it { is_expected.to respond_to :stale }
    it { is_expected.to respond_to :program_id }
    it { is_expected.to respond_to :created_at }
    it { is_expected.to respond_to :updated_at }
  end

  describe 'instance methods' do 
  end

  describe 'validations' do 
    let(:listing) { FactoryGirl.build(:listing) }

    it 'is invalid without a title' do 
      listing.title = nil
      expect(listing).not_to be_valid
    end
  end

  describe 'associations' do 
  end
end