require 'spec_helper'

describe Listing, listings: true do 

  describe 'attributes' do 
    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :season_id }
    it { is_expected.to respond_to :created_at }
    it { is_expected.to respond_to :updated_at }
  end

  describe 'instance methods' do 
    let(:listing) { FactoryGirl.create(:listing) }

    describe '#to_h' do 
      let(:hash) {
        {
          id: listing.id,
          season_id: listing.season_id,
          title: listing.title,
          created_at: listing.created_at
        }
      }

      it 'returns a hash of non-blank attributes' do
        expect(listing.to_h).to eql hash
      end

      it 'is aliased as #to_hash' do 
        expect(listing.to_h).to eql listing.to_hash
      end

      it 'returns any attributes that are not blank' do 
        listing.update(title: 'My Super Awesome Listing')
        expect(listing.to_h).to have_key(:updated_at)
      end
    end

    describe '#to_json' do 
      it 'converts hash to JSON object' do 
        expect(listing.to_json).to eql(listing.to_h.to_json)
      end
    end
  end

  describe 'validations' do 
    let(:listing) { FactoryGirl.create(:listing) }

    it 'is invalid without a title' do 
      listing.title = nil
      expect(listing).not_to be_valid
    end
  end

  describe 'associations' do
    it 'is destroyed with its season' do 
      season = FactoryGirl.create(:season_with_listing)
      listing = season.listing 
      season.destroy
      expect(Listing[listing.id]).to be nil
    end
  end
end