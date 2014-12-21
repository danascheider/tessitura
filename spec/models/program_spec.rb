require 'spec_helper'

describe Program do 
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
end