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
    #
  end
end