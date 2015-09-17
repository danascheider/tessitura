require File.expand_path('../version.rb', __FILE__)
require File.expand_path('../files.rb', __FILE__)

Gem::Specification.new do |s|
  s.specification_version     = 1 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version
  s.required_ruby_version     = '>= 2.2.2'

  s.name                      = 'tessitura'
  s.version                   = TessituraPackage::Version::STRING
  s.date                      = '2015-09-17'
  s.summary                   = 'Tessitura task management for opera singers'
  s.authors                   = ['Dana Scheider']

  s.files                     = TessituraPackage::Files::FILES
  s.require_paths             = ['config', 'bin', 'db', 'lib', 'script', 'tasks']
  s.test_files                = s.files.select {|path| path =~ /^(spec|features)\/.*\.(rb|feature)/ }
  s.extra_rdoc_files          = %w(README.rdoc)

  s.executables               = ['tessitura']
  s.default_executable        = 'tessitura'

  s.add_runtime_dependency     'google-api-client', '~> 0.8', '>= 0.8.6'
  s.add_runtime_dependency     'json', '~> 1.8.1'
  s.add_runtime_dependency     'mysql2', '~> 0.3', '>= 0.3.16'
  s.add_runtime_dependency     'rack-cors', '~> 0.4'
  s.add_runtime_dependency     'rack-ssl-enforcer', '~> 0.2', '>= 0.2.8'
  s.add_runtime_dependency     'reactive_extensions', '~> 0.5'
  s.add_runtime_dependency     'reactive_support', '~> 0.5'
  s.add_runtime_dependency     'sequel', '~> 4.21'
  s.add_runtime_dependency     'sinatra', '~> 1.4', '>= 1.4.6'
  s.add_runtime_dependency     'slogger', '~> 0.0', '>= 0.0.11'
  s.add_runtime_dependency     'thin', '~> 1.6', '>= 1.6.3'

  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'coveralls', '~> 0.7', '>= 0.7.2'
  s.add_development_dependency 'simplecov', '~> 0.10'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'json_spec', '~> 1.1'
  s.add_development_dependency 'cucumber', '~> 2.1'
  s.add_development_dependency 'cucumber-sinatra', '~> 0.5.0'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'rack-test', '~> 0.6.3'
  s.add_development_dependency 'capybara-webkit', '~> 1.5'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'colorize', '~> 0.7'

  s.has_rdoc         = true
  s.homepage         = 'http://github.com/danascheider/tessitura'
  s.rdoc_options     = %w(--line-numbers --inline-source --title Tessitura)
  s.rubygems_version = '1.1.1'
end
