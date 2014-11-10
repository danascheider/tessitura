require 'yaml'

module DatabaseTaskHelper
  def self.get_yaml(file)
    yaml = File.open(file, 'r+') {|file| YAML.load(file) }

    [yaml['development'], yaml['test'], yaml['production']].each do |hash|
      hash.keys.each do |key|
        hash[(key.to_sym rescue key) || key] = hash.delete(key)
      end
    end

    yaml
  end

  def self.get_string(hash, env)
    "#{hash[:adapter]}://#{hash[:username]}:#{hash[:password]}@#{hash[:host]}:#{hash[:port]}/#{env}"
  end
end