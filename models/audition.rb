class Audition < Sequel::Model
  # many_to_one :season

  # Auditions are required to have a country, city, and date. If the audition is in
  # the US, a state is also required.

  def validate
    super
    validates_presence [:country, :city, :date]
    validates_presence :region if country === 'USA'
  end
end