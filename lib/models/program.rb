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

  # The ++#owner++ method returns the organization that owns the program. Likewise, the
  # ++#owner_id++ method returns the ID of that organization. This enables
  # standardization of handlers that retrieve Canto resources.
  #
  # NOTE: These methods cannot be refactored using ++alias_method++. Due to the internals
  #       of the ORM, ++alias_method++ will be called in the Travis environment before
  #       the attribute accessor methods from Sequel::Model are implemented, resulting
  #       in a NoMethodError before the tests even run.

  def owner; organization; end
  def owner_id; organization_id; end

  # The ++#to_hash++ or ++#to_h++ method returns all non-empty attributes in a hash
  # with symbol keys.

  def to_hash
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  # The ++#to_json++ method converts the output of ++#to_hash++ to JSON format, preventing
  # inscrutable JSON objects like ++"\"#<Program:0x00000004b050c8>\""++.
  #
  # NOTE: The definition of ++#to_json++ has to include the optional ++opts++
  #       arg, because in some of the tests, a JSON::Ext::Generator::State
  #       object is passed to the method. I am not sure why this happens,
  #       but including the optional arg makes it work as expected.

  def to_json(opts={})
    to_h.to_json
  end

  # The ++validate++ method verifies that the program has a ++:name++ and an
  # ++:organization_id++, returning a ++Sequel::ValidationError++ if these 
  # conditions are not met. It also calls the ++validate++ method inherited 
  # from the ++Sequel::Model++ instance, which is made available by the
  # ++:validation_helpers++ plugin.

  def validate
    validates_presence [:name, :organization_id]
  end
end