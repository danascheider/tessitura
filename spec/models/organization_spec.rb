require 'spec_helper'

describe Organization, organizations: true do
  describe 'attributes' do 
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:address_1) }
    it { is_expected.to respond_to(:address_2) }
    it { is_expected.to respond_to(:city) }
    it { is_expected.to respond_to(:region) }
    it { is_expected.to respond_to(:postal_code) }
    it { is_expected.to respond_to(:country) }
    it { is_expected.to respond_to(:website) }
    it { is_expected.to respond_to(:contact_name) }
    it { is_expected.to respond_to(:phone_1) }
    it { is_expected.to respond_to(:phone_2) }
    it { is_expected.to respond_to(:email_1) }
    it { is_expected.to respond_to(:email_2) }
    it { is_expected.to respond_to(:fax) }
  end

  describe 'instance methods' do 
    let(:organization) { FactoryGirl.create(:organization) }

    describe '#to_h' do 
      let(:hash) {
        {
          name: organization.name,
          website: organization.website,
          created_at: organization.created_at,
          id: organization.id,
          type: 'Organization'
        }
      }

      it 'returns non-blank attributes in a hash' do 
        expect(organization.to_h).to eql hash
      end

      it 'is aliased to #to_hash' do 
        expect(organization.to_hash).to eql organization.to_h
      end

      it 'includes any attributes that are defined' do 
        organization.update(city: 'Paris')
        expect(organization.to_h).to have_key(:city)
      end
    end

    describe '#to_json' do 
      it 'converts to a hash first' do 
        expect(organization.to_json).to eql organization.to_h.to_json
      end
    end
  end

  describe 'validations' do 
    let(:org) { FactoryGirl.build(:organization) }

    it 'is invalid without a name' do 
      org.name = nil 
      expect(org).not_to be_valid
    end

    it 'is valid without a web site' do 
      org.website = nil
      expect(org).to be_valid
    end

    it 'is invalid with web site in a wrong format' do 
      org.website = 'lyricopera.org'
      expect(org).not_to be_valid
    end

    it 'is valid with http:// website' do 
      org.website = 'http://example.com'
      expect(org).to be_valid
    end

    it 'is valid with https:// website' do 
      org.website = 'https://www.examples.ac.uk'
      expect(org).to be_valid
    end
  end
end