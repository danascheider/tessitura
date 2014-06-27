require 'spec_helper'

describe Task do 
  it { should respond_to(:title) }
  it { should respond_to(:incomplete?) }
  it { should respond_to(:to_hash) } # to integrate with Sinatra-Backbone
end