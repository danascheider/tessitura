class Audition < Sequel::Model
  many_to_one :season

  # The ++#to_hash++ or ++#to_h++ method returns all non-empty attributes in a hash
  # with symbol keys.

  def to_hash
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  # The ++#to_json++ method converts the output of ++#to_hash++ to JSON format, preventing
  # inscrutable JSON objects like ++"\"#<Audition:0x00000004b050c8>\""++.
  #
  # NOTE: The definition of ++#to_json++ has to include the optional ++opts++
  #       arg, because in some of the tests, a JSON::Ext::Generator::State
  #       object is passed to the method. I am not sure why this happens,
  #       but including the optional arg makes it work as expected.

  def to_json(opts={})
    to_h.to_json
  end

  # Auditions are required to have a country, city, and date. If the audition is in
  # the US, a state is also required. The ++validate++ method first calls ++super++,
  # invoking the ++validate++ method on the ++Sequel::Model++ instance. (This method
  # is added by the ++validation_helper++ plugin.) It then raises a 
  # ++Sequel::ValidationError++ if any of the required fields are missing.

  def validate
    super
    validates_presence [:country, :city, :date]
    validates_presence :region if country === 'USA'
  end
end