require 'spec_helper'

describe Task do 
  it { should respond_to(:title) }
  it { should respond_to(:incomplete?) }
end