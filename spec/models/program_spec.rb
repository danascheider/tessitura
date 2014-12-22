require 'spec_helper'

describe Program, programs: true do 
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:type) }
  it { is_expected.to respond_to(:min_age) }
  it { is_expected.to respond_to(:max_age) }
  it { is_expected.to respond_to(:website) }
  it { is_expected.to respond_to(:country) }
  it { is_expected.to respond_to(:region) }
  it { is_expected.to respond_to(:city) }
  it { is_expected.to respond_to(:contact_name) }
  it { is_expected.to respond_to(:contact_email) }
  it { is_expected.to respond_to(:contact_phone) }
  it { is_expected.to respond_to(:organization_id) }

  describe 'associations' do 
    it 'is destroyed with its organization' do 
      org = FactoryGirl.create(:organization_with_everything)
      programs = org.programs 
      org.destroy 
      programs.each {|p| expect(Season[p.id]).to be nil }
    end
  end

  describe 'instance methods' do 
    let(:program) { FactoryGirl.create(:program) }

    describe '#to_h' do 
      let(:hash) {
        {
          id: program.id, 
          organization_id: program.organization_id,
          name: program.name,
          type: program.type,
          country: program.country,
          region: program.region,
          city: program.city,
          created_at: program.created_at
        }
      }

      it 'returns a hash of the program\'s non-blank attributes' do 
        expect(program.to_h).to eql hash
      end

      it 'includes any attributes that aren\'t blank' do 
        program.update(min_age: 18)
        expect(program.to_h).to have_key(:min_age)
      end

      it 'aliases #to_hash' do 
        expect(program.to_h).to eql program.to_hash
      end
    end

    describe '#to_json' do 
      it 'converts to a hash first' do 
        expect(program.to_json).to eql(program.to_h.to_json)
      end
    end
  end
end