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

  describe 'associations' do 
    it 'is destroyed with its program' do 
      program = FactoryGirl.create(:program_with_everything)
      seasons = program.seasons
      program.destroy
      seasons.each {|s| expect(Season[s.id]).to be nil }
    end
  end

  describe 'instance methods' do 
    let(:season) { FactoryGirl.create(:season) }

    describe '#to_h' do 
      let(:hash) {
        {
          id: season.id,
          program_id: season.program_id,
          final_deadline: season.final_deadline,
          start_date: season.start_date,
          created_at: season.created_at
        }
      }

      it 'returns a hash of non-blank attributes' do 
        expect(season.to_h).to eql hash
      end

      it 'returns any attributes that are not blank' do 
        season.update(program_fees: 2750)
        expect(season.to_h).to have_key(:program_fees)
      end

      it 'aliases #to_hash' do 
        expect(season.to_h).to eql season.to_hash
      end
    end

    describe '#to_json' do 
      it 'converts to a hash first' do 
        expect(season.to_json).to eql season.to_h.to_json
      end
    end
  end
end