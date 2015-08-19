module TessituraPackage
  def self.gem_version
    Gem::Version.new Version::STRING
  end

  module Version
    MAJOR = '0'
    MINOR = '3'
    PATCH = '0'
    PRE   = 'alpha1.test'

    STRING = [MAJOR, MINOR, PATCH, PRE].join('.').chomp('.')
  end
end
