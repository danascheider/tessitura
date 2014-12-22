# An Organization is any organization offering or affliated with 
# programs of interest to Canto subscribers. They may be, among 
# other things, opera companies, summer programs, churches, choirs, 
# university departments, or community organizations.

class Organization < Sequel::Model
  one_to_many :programs
  self.plugin :association_dependencies, programs: :destroy

  def to_hash
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  # The `#to_json` method converts the output of `#to_hash` to JSON format, preventing
  # inscrutable JSON objects like `"\"#<Organization:0x00000004b050c8>\""`.

  def to_json
    to_h.to_json
  end
end