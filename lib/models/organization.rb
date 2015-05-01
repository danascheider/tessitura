# An Organization is any organization offering or affliated with 
# programs of interest to Canto subscribers. They may be, among 
# other things, opera companies, summer programs, churches, choirs, 
# university departments, or community organizations.

class Organization < Sequel::Model
  one_to_many :programs
  self.plugin :association_dependencies, programs: :destroy

  # The `#to_hash` or `#to_h` method returns all non-empty attributes in a hash
  # with symbol keys.

  def to_hash
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  # The `#to_json` method converts the output of `#to_hash` to JSON format, preventing
  # inscrutable JSON objects like `"\"#<Organization:0x00000004b050c8>\""`.
  #
  # NOTE: The definition of `#to_json` has to include the optional `opts`
  #       arg, because in some of the tests, a JSON::Ext::Generator::State
  #       object is passed to the method. I am not sure why this happens,
  #       but including the optional arg makes it work as expected.

  def to_json(opts={})
    to_h.to_json
  end

  # An Organization object is required to have a name and a valid web site.

  def validate
    super
    validates_presence [:name, :website]
    validates_format /http(s?)\:\/\/\w+\..*/, :website, message: 'not a valid web site URL'
  end
end