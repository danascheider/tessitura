module CantoPackage
  def self.files
    Files::FILES
  end

  module Files
    LIB_FILES = Dir.glob('./lib/**/*.rb').sort
    CONFIG_FILES = Dir.glob('./config/*').sort
    SCRIPT_FILES = Dir.glob('./script/**/*').sort
    LOG_FILES = Dir.glob('./log/**/*').sort
    BIN_FILES = Dir.glob('./bin/**/*').sort
    TASK_FILES = ['Rakefile', Dir.glob('./tasks/**/*.rake')].flatten.sort
    TEST_FILES = [Dir.glob('./spec/**/*.rb'), Dir.glob('./features/**/*')].flatten.sort
    BASE_FILES = %w(files.rb Gemfile Vagrantfile config.ru canto.gemspec README.rdoc version.rb)

    FILES = [LIB_FILES, CONFIG_FILES, SCRIPT_FILES, BIN_FILES, TASK_FILES, LOG_FILES, TEST_FILES, BASE_FILES].flatten
  end
end