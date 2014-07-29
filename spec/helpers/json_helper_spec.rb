require 'spec_helper' 

describe Canto::JSONHelper do 
  include Canto::JSONHelper
  include Rack::Test::Methods
  include Rack

  describe '::request_body' do 
    context 'request body is a valid JSON object' do 
      it 'returns the body as a hash' do
        hash = { foo: 'bar'}
        dbl = double()
        req = Rack::Request.new(body: hash.to_json)
        expect(request_body(req)).to eql hash
      end
    end
  end
end