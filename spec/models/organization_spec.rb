require 'spec_helper'

describe Organization do
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
          id: organization.id,
          name: organization.name,
          created_at: organization.created_at
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
end