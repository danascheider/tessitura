class String
  def to_date
    s = self.split(/\-/).map(&:to_i)
    Date.new(s[0],s[1],s[2]) rescue nil
  end
end

module Sinatra
  module GeneralHelperMethods
    def request_body
      request.body.rewind
      (body = parse_json(request.body.read)).each {|k,v| body[k] = v.try_rescue(:to_date) || v }
    end
    
    def return_json(obj)
      obj.to_json unless obj.blank?
    end

    def sanitize_attributes(hash)
      hash.clean(:id, :created_at, :updated_at, :owner_id)
    end

    def sanitize_attributes!(hash)
      hash.clean!(:id, :created_at, :updated_at, :owner_id)
    end
  end
end