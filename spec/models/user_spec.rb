require 'spec_helper'

describe User do 
  describe 'attributes' do 
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:email) }
    it { should respond_to(:birthdate) }
    it { should respond_to(:city) }
    it { should respond_to(:country) }
    it { should respond_to(:fach) }
    it { should respond_to(:admin) }
  end

  describe 'instance methods' do
    it { should respond_to(:admin?) }
    it { should respond_to(:name) }
  end
end