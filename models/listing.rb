class Listing < Sequel::Model
  many_to_one :season

  def validate
    super
    validates_presence [:title, :season_id]
  end
end