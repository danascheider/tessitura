class Listing < Sequel::Model
  many_to_one :season
  many_to_many :users, left_key: :listing_id, right_key: :user_id, join_table: :listings_users

  def validate
    super
    validates_presence [:title, :season_id]
  end
end