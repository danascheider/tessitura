require 'spec_helper'

describe Season do 
  it { is_expected.to respond_to :start_date }
  it { is_expected.to respond_to :end_date }
  it { is_expected.to respond_to :early_bird_deadline }
  it { is_expected.to respond_to :priority_deadline }
  it { is_expected.to respond_to :final_deadline }
  it { is_expected.to respond_to :payments } 
  it { is_expected.to respond_to :program_fees }
  it { is_expected.to respond_to :peripheral_fees }
  it { is_expected.to respond_to :application_fee }
  it { is_expected.to respond_to :stale }
  it { is_expected.to respond_to :program_id }
  it { is_expected.to respond_to :created_at }
  it { is_expected.to respond_to :updated_at }
end