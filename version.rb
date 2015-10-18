module TessituraPackage
  def self.gem_version
    Gem::Version.new Version::STRING
  end

  module Version
    MAJOR = '0'
    MINOR = '4'
    PATCH = '0'
    PRE   = 'alpha2'

    STRING = [MAJOR, MINOR, PATCH, PRE].join('.').chomp('.')
  end
end
