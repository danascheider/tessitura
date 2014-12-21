require 'spec_helper'

describe Organization do
  describe 'instance methods' do 
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
end