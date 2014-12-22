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

  def to_json
    to_h.to_json
  end
end