# A Season represents all information about a Program that is specific to this
# year or cycle. It includes information like deadlines and fees and is also
# the owner of Audition and Listing objects.

class Season < Sequel::Model
  one_to_one :listing
  one_to_many :auditions
  many_to_one :program

  self.plugin :association_dependencies, listing: :destroy
  self.plugin :association_dependencies, auditions: :destroy

  # The `#to_hash` or `#to_h` method returns all non-empty attributes in a hash
  # with symbol keys.

  def to_hash 
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  # The `#to_json` method converts the output of `#to_hash` to JSON format, preventing
  # inscrutable JSON objects like `"\"#<Season:0x00000004b050c8>\""`.
  #
  # NOTE: The definition of `#to_json` has to include the optional `opts`
  #       arg, because in some of the tests, a JSON::Ext::Generator::State
  #       object is passed to the method. Including the optional argument
  #       prevents an `ArgumentError`.

  def to_json(opts={})
    to_h.to_json
  end

  # Seasons are required to belong to programs and are meaningless without them, since
  # the model is specifically intended to store time-sensitive information about a program.

  def validate
    super
    validates_presence :program_id
  end
end