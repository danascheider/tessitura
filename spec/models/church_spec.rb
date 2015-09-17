require 'spec_helper'

describe Church, churches: true do 
  describe 'attributes' do 
    context 'general organization attributes' do 
      attributes = [:name, :address_1, :address_2, :city, :state, :country, :postal_code, :phone_1, :phone_2, :email_1, :email_2, :fax, :website, :contact_name]

      attributes.each do |attribute|
        it { is_expected.to respond_to(attribute) }
      end
    end
  end
end