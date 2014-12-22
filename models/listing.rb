class Listing < Sequel::Model
  many_to_one :season

  def validate
    super
    validates_presence [:title, :season_id]
  end

  # The `#to_h` or `#to_hash` method returns a hash of the non-blank
  # attributes of the listing.

  def to_hash
    {
      id: id,
      season_id: season_id,
      title: title,
      created_at: created_at,
      updated_at: updated_at
    }.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  # The `#to_json` method converts the output of `#to_hash` to JSON format, preventing
  # inscrutable JSON objects like `"\"#<Listing:0x00000004b050c8>\""`.
  #
  # NOTE: The definition of `#to_json` has to include the optional `opts`
  #       arg, because in some of the tests, a JSON::Ext::Generator::State
  #       object is passed to the method. I am not sure why this happens,
  #       but including the optional arg makes it work as expected.

  def to_json(opts={})
    to_h.to_json
  end
end