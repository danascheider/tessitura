class Audition < Sequel::Model
  many_to_one :season

  # The `#to_hash` or `#to_h` method returns all non-empty attributes in a hash
  # with symbol keys.

  def to_hash
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  # The `#to_json` method converts the output of `#to_hash` to JSON format, preventing
  # inscrutable JSON objects like `"\"#<Audition:0x00000004b050c8>\""`.

  def to_json
    to_h.to_json
  end

  # Auditions are required to have a country, city, and date. If the audition is in
  # the US, a state is also required.

  def validate
    super
    validates_presence [:country, :city, :date]
    validates_presence :region if country === 'USA'
  end
end