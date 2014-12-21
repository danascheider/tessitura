# A Program is any single program, production, or ensemble that may be
# of interest to our subscribers. This model stores information about
# these things that will not be stored at either the Organization or 
# Season level: Things specific to the program but not tied to a 
# particular season. For example, deadlines and fees change from year
# to year, but a contact person or type of program, though mutable, 
# is not specific to one cycle.

class Program < Sequel::Model
  many_to_one :organization
end