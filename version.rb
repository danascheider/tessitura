module TessituraPackage
  def self.gem_version
    Gem::Version.new Version::STRING
  end

  module Version
    MAJOR = '0'
    MINOR = '0'
    PATCH = '1'
    PRE   = 'alpha7'

    STRING = [MAJOR, MINOR, PATCH, PRE].join('.').chomp('.')
  end
end
