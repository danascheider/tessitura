# A Program is any single program, production, or ensemble that may be
# of interest to our subscribers. This model stores information about
# these things that will not be stored at either the Organization or 
# Season level: Things specific to the program but not tied to a 
# particular season. For example, deadlines and fees change from year
# to year, but a contact person or type of program, though mutable, 
# is not specific to one cycle.

class Program < Sequel::Model
  many_to_one :organization
  one_to_many :seasons
  many_to_many :users, left_key: :program_id, right_key: :user_id, join_table: :programs_users

  self.plugin :association_dependencies, seasons: :destroy

  def to_hash
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  def to_json
    to_h.to_json
  end
end