module TessituraPackage
  def self.gem_version
    Gem::Version.new Version::STRING
  end

  module Version
    MAJOR = '0'
    MINOR = '1'
    PATCH = '0'
    PRE   = 'alpha1'

    STRING = [MAJOR, MINOR, PATCH, PRE].join('.').chomp('.')
  end
end
