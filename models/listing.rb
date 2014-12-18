class Listing < Sequel::Model

  # Listings require pretty much all information that all programs will be 
  # guaranteed to have. Customers will use this information to make decisions
  # and listings will not be useful to them without it.

  def validate
    super
    validates_presence [:title, :web_site, :country, :city, :program_start_date]
  end
end