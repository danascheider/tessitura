require 'spec_helper'

describe Audition do 
  it { is_expected.to respond_to :country }
  it { is_expected.to respond_to :region }
  it { is_expected.to respond_to :city }
  it { is_expected.to respond_to :date }
  it { is_expected.to respond_to :deadline }
  it { is_expected.to respond_to :created_at }
  it { is_expected.to respond_to :updated_at }

  describe 'associations' do 
    #
  end
end