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
      convert_dates(body = parse_json(request.body.read)) || body.try_rescue(:each) {|h| convert_dates(h)}
    end

    def convert_dates(hash)
      return nil unless hash.is_a? Hash
      hash.each {|k,v| hash[k] = v.try_rescue(:to_date) || v }
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