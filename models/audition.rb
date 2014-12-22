class Audition < Sequel::Model
  many_to_one :season

  # The `#to_hash` or `#to_h` method returns all non-empty attributes in a hash
  # with symbol keys.

  def to_hash
    {
      id: id,
      season_id: season_id,
      country: country,
      region: region,
      city: city,
      date: date,
      deadline: deadline,
      fee: fee,
      pianist_provided: pianist_provided,
      can_bring_own_pianist: can_bring_own_pianist,
      pianist_fee: pianist_fee,
      created_at: created_at,
      updated_at: updated_at
    }.reject {|k,v| v.blank? }
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