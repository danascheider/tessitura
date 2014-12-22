# A Season represents all information about a Program that is specific to this
# year or cycle. It includes information like deadlines and fees and is also
# the owner of Audition and Listing objects.

class Season < Sequel::Model
  one_to_one :listing
  one_to_many :auditions
  many_to_one :program

  self.plugin :association_dependencies, listing: :destroy
  self.plugin :association_dependencies, auditions: :destroy

  def to_hash 
    super.reject {|k,v| v.blank? }
  end

  alias_method :to_h, :to_hash

  def to_json
    to_h.to_json
  end
end