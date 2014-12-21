# An Organization is any organization offering or affliated with 
# programs of interest to Canto subscribers. They may be, among 
# other things, opera companies, summer programs, churches, choirs, 
# university departments, or community organizations.

class Organization < Sequel::Model
  one_to_many :programs
  self.plugin :association_dependencies, programs: :destroy
end