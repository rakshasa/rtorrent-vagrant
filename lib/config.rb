# -*- mode: ruby -*-

require 'json'

def parse_config_file(name)
  config_file = File.expand_path(File.join('../config/', "#{name}.yml"), File.dirname(__FILE__))

  deep_symbolize_keys(YAML.load(File.open(config_file).read))
end

