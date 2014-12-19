class Audition < Sequel::Model
  many_to_one :listing
end