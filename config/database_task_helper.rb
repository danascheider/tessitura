require 'yaml'

module DatabaseTaskHelper
  
  def self.get_yaml(file)
    yaml = File.open(file, 'r+') {|file| YAML.load(file) }

    yaml['defaults'].keys.each do |key|
      yaml['defaults'][(key.to_sym rescue key) || key] = hash.delete(key)
    end

    yaml
  end

  # Example:
  #     hash = DatabaseTaskHelper.get_yaml('database.yml')['test']
  #     DatabaseTaskHelper.get_string(hash, 'test')
  #         # => "mysql2://root:rootpassword@localhost:3306/test"

  def self.get_string(hash, env)
    "#{hash[:adapter]}://#{hash[:username]}:#{hash[:password]}@#{hash[:host]}:#{hash[:port]}/#{env}"
  end
end