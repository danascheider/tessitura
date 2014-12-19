class Listing < Sequel::Model

  # Listings require pretty much all information that all programs will be 
  # guaranteed to have. Customers will use this information to make decisions
  # and listings will not be useful to them without it.

  # There should be some sort of validation for web site format or, ideally,
  # validity. However, it is unclear what that should actually be

  def validate
    super
    validates_presence [:title, :web_site, :country, :city, :program_start_date]
    validates_format /(.*)\.(.*)/, :web_site
  end
end